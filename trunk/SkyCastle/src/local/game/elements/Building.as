package local.game.elements
{
	import bing.amf3.ResultEvent;
	import bing.utils.SystemUtil;
	
	import flash.utils.clearTimeout;
	
	import local.comm.GameData;
	import local.comm.GameRemote;
	import local.comm.GameSetting;
	import local.enum.BasicPickup;
	import local.enum.BuildingOperation;
	import local.enum.BuildingStatus;
	import local.enum.ItemType;
	import local.enum.PayType;
	import local.enum.QuestType;
	import local.game.GameWorld;
	import local.model.MapGridDataModel;
	import local.model.PlayerModel;
	import local.model.QuestModel;
	import local.model.ShopModel;
	import local.model.StorageModel;
	import local.model.buildings.vos.BuildingVO;
	import local.model.vos.RewardsVO;
	import local.model.vos.ShopItemVO;
	import local.model.vos.StorageItemVO;
	import local.utils.CharacterManager;
	import local.utils.CollectQueueUtil;
	import local.utils.GameUtil;
	import local.utils.PickupUtil;
	import local.utils.SoundManager;
	import local.views.CenterViewContainer;
	import local.views.alert.SellBuildingAlert;
	import local.views.effects.MapWordEffect;
	import local.views.tooltip.BuildingToolTip;
	
	public class Building extends BaseBuilding
	{
		protected var _timeoutId:int ;
		protected var _currentRewards:RewardsVO ; //接口返回的奖励
		protected var _executeBack:Boolean ; //接口是否返回
		protected var _timeoutFlag:Boolean ; //进度条是否完成
		
		private var _ro:GameRemote ;
		public function get ro():GameRemote{
			if(!_ro) {
				_ro = new GameRemote("CommService");
				_ro.addEventListener(ResultEvent.RESULT ,  onResultHandler );
			}
			return _ro ;
		}
		
		public function Building(vo:BuildingVO)
		{
			super(vo);
		}
		
		/**
		 * 发送操作到服务器
		 */		
		public function sendOperation( operation:String ):void
		{
			this.enable=false ;
			switch( operation )
			{
				case BuildingOperation.BUY:
					this.buildingVO.buildingStatus=BuildingStatus.BUILDING ;
					showPlaceEffect();
					CharacterManager.instance.updateCharactersPos( this );
					//发送数据
					ro.getOperation("buy").send( buildingVO.shopItemId , nodeX,nodeZ );
					SoundManager.instance.playSoundBulidDown();
					break ;
				case BuildingOperation.ROTATE:
					buildingVO.scale = scaleX ;
					CharacterManager.instance.updateCharactersPos( this );
					//发送数据
					ro.getOperation("rotate").send( buildingVO.id , buildingVO.scale );
					break ;
				case BuildingOperation.STASH:
					//发送数据
					ro.getOperation("stash").send( buildingVO.id );
					break ;
				case BuildingOperation.MOVE:
					showPlaceEffect();
					CharacterManager.instance.updateCharactersPos( this );
					//发送数据
					ro.getOperation("move").send( buildingVO.id , nodeX,nodeZ );
					SoundManager.instance.playSoundBulidDown();
					break ;
				case BuildingOperation.SELL :
					this.enable=true ;
					var shopItemVO:ShopItemVO = ShopModel.instance.getBuildingShopItemByBaseId( baseBuildingVO.baseId, baseBuildingVO.type);
					if(shopItemVO){
						var coin:int ;
						if(shopItemVO.payType==PayType.CASH){
							coin = GameUtil.cashToCoin(shopItemVO.price)>>1 ;
						}else{
							coin = shopItemVO.price ;
						}
						coin=coin>>1 ;
						SellBuildingAlert.show( coin+"" , baseBuildingVO.baseId, "Are you sure to sell it?",
							function():void{
								enable = false ;
								ro.getOperation("sell").send(buildingVO.id);
							}
						);
					}
					break ;
				case BuildingOperation.PLACE_STASH:
					showPlaceEffect();
					GameData.buildingCurrOperation = BuildingOperation.NONE ;
					CharacterManager.instance.updateCharactersPos( this );
					//发送数据
					ro.getOperation("placeStash").send( buildingVO.id , nodeX,nodeZ );
					//从收藏箱中删除此storageItem
					StorageModel.instance.deleteBuilding( buildingVO );
					SoundManager.instance.playSoundBulidDown();
					break ;
			}
		}
		
		protected function onResultHandler( e:ResultEvent ):void
		{
			SystemUtil.debug("返回数据：",e.service+"."+e.method , e.result);
			this.enable=true ;
			switch( e.method)
			{
				case "buy":
					if(e.result){
						//掉修建经验
						var value:int = baseBuildingVO.buildEarnExp;
						if(value>0)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_EXP , value,screenX,screenY+offsetY*0.5);
						this.buildingVO = e.result as BuildingVO;
						if(baseBuildingVO.type!=ItemType.BUILDING_HOUSE && baseBuildingVO.type!=ItemType.BUILDING_FACTORY)
						{
							//任务统计
							QuestModel.instance.updateQuests( QuestType.BUILD_NUM , baseBuildingVO.baseId ,1 , buildingVO.buildTime );
							QuestModel.instance.updateQuests( QuestType.OWN_BUILDING , baseBuildingVO.baseId );
						}
					}else{
						GameWorld.instance.removeBuildFromScene(this);
					}
					break ;
				case "stash":
					if(e.result){
						PlayerModel.instance.me.rank-=baseBuildingVO.rank ;
						StorageModel.instance.addStorageItem( e.result as StorageItemVO );
						GameWorld.instance.removeBuildFromScene(this);
						this.showStashEffect();
						//任务统计
						QuestModel.instance.updateQuests( QuestType.OWN_BUILDING , baseBuildingVO.baseId );
						//清理
						dispose();
					}
					break ;
				case "sell":
					if(e.result){
						PlayerModel.instance.me.rank-=baseBuildingVO.rank ;
						var shopItemVO:ShopItemVO = ShopModel.instance.getBuildingShopItemByBaseId( baseBuildingVO.baseId, baseBuildingVO.type);
						var coin:int ;
						if(shopItemVO.payType==PayType.CASH){
							coin = GameUtil.cashToCoin(shopItemVO.price) ;
						}else{
							coin = shopItemVO.price ;
						}
						coin=coin>>1 ;
						PlayerModel.instance.me.coin+=coin ;
						GameWorld.instance.removeBuildFromScene(this);
						this.showStashEffect();
						//任务统计
						QuestModel.instance.updateQuests( QuestType.OWN_BUILDING , baseBuildingVO.baseId );
						//清理
						dispose();
					}
					break ;
				case "rotate":
					break ;
				case "move":
					break ;
				case "placeStash":
					break ;
			}
		}
		
		override public function onClick():void
		{
			enable = false ;
			CollectQueueUtil.instance.addBuilding( this ); //添加到处理队列中
		}
		
		/**
		 * 人移动到此建筑旁边或上面 
		 * @param character
		 */
		public function characterMoveTo( character:Character):void
		{
			var result:Boolean ;
			if(!baseBuildingVO.walkable){
				var nx:int , nz:int ;
				nx = _isRotate? nodeX + _zSpan: nodeX + _xSpan ;
				if(nx<=GameSetting.GRID_X && nx>=0 && MapGridDataModel.instance.astarGrid.getNode(nx,nodeZ).walkable) {
					result = character.searchToRun( nx,nodeZ);
				}
				if(!result)
				{
					nz = _isRotate?nodeZ + _xSpan:nodeZ + _zSpan;
					if(nz<=GameSetting.GRID_Z && nz>=0 && MapGridDataModel.instance.astarGrid.getNode(nodeX,nz).walkable) {
						result = character.searchToRun( nodeX,nz);
					}
				}
				if(!result)
				{
					nx = nodeX-1 ;
					if(nx<=GameSetting.GRID_X && nx>=0 && MapGridDataModel.instance.astarGrid.getNode(nx,nodeZ).walkable) {
						result = character.searchToRun( nx,nodeZ);
					}
				}
				if(!result)
				{
					nz = nodeZ-1 ;
					if(nz<=GameSetting.GRID_Z && nz>=0 && MapGridDataModel.instance.astarGrid.getNode(nodeX,nz).walkable) {
						result = character.searchToRun( nodeX,nz);
					}
				}
				if(!result)
				{
					var arr:Array = getRoundAblePoint(); 
					if(arr.length>0){
						arr.sortOn("z", Array.DESCENDING|Array.NUMERIC );
						result = character.searchToRun( arr[0].x/_size , arr[0].z/_size);
					}
				}
				
			}else{
				result = character.searchToRun( nodeX , nodeZ );
			}
			if(character is Hero && !result) 
			{
				var effect:MapWordEffect = new MapWordEffect("I can 't get here!");
				GameWorld.instance.addEffect( effect , screenX , screenY);
				CollectQueueUtil.instance.clear(true); //不能走到建筑旁边，则清除队列
			}
		}
		
		/**
		 * 英雄移动到建筑旁边，开始执行动作 
		 */		
		public function execute():Boolean
		{
			itemLayer.alpha=1 ;
			if(stepLoading&&stepLoading.parent){
				stepLoading.parent.removeChild(stepLoading);
			}
			_currentRewards = null ;
			_executeBack = false ;
			return true ;
		}
		
		/**
		 * 调用execute时减一个能量
		 * @return 
		 */		
		protected function executeReduceEnergy( value:int = 1 ):Boolean
		{
			//减能量
			var effect:MapWordEffect ;
			if(PlayerModel.instance.me.energy>=1){
				effect = new MapWordEffect("Energy -"+value);
				PlayerModel.instance.me.energy-=value ;
				CenterViewContainer.instance.topBar.updateEnergy();
				GameWorld.instance.addEffect(effect,screenX,screenY);
			}else{
				CollectQueueUtil.instance.clear(true);
				effect = new MapWordEffect("You don't have enough Energy!");
				GameWorld.instance.addEffect(effect,screenX,screenY);
				//能量不够，弹出购买能量的窗口
				return  false;
			}
			return true;
		}
		
		/**
		 * 掉物品 ，并接着下一个收集
		 */		
		public function showPickup():void
		{
			enable=true ;
			itemLayer.filters=null;
			CollectQueueUtil.instance.nextBuilding();
		}
		
		/**
		 * 返回奖励的item 
		 */		
		protected function showRewardsPickup():void
		{
			if(_currentRewards){
				//掉pickup
				if(_currentRewards.coin>0)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_COIN , _currentRewards.coin,screenX,screenY+offsetY*0.5);
				if(_currentRewards.exp>0)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_EXP , _currentRewards.exp,screenX,screenY+offsetY*0.5);
				if(_currentRewards.stone>0)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_STONE , _currentRewards.stone,screenX,screenY+offsetY*0.5);
				if(_currentRewards.wood>0)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_WOOD , _currentRewards.wood,screenX,screenY+offsetY*0.5);
				if(_currentRewards.pickups){
					var len:int = _currentRewards.pickups.length ;
					for( var i:int = 0 ; i<len ; ++i){
						PickupUtil.addPickup2Wold( _currentRewards.pickups[i] , 1 ,screenX,screenY+offsetY*0.5);
					}
				}
			}
		}
		
		/*进度条时间完成*/
		protected function timeoutHandler():void{
			_timeoutFlag = true ; 
			showPickup();
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_timeoutId>0){
				clearTimeout(_timeoutId);
			}
			if(_ro){
				_ro.removeEventListener(ResultEvent.RESULT ,  onResultHandler );
				_ro.dispose();
				_ro = null ;
			}
		}
	}
}