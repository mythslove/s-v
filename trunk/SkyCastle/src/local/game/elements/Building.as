package local.game.elements
{
	import bing.amf3.ResultEvent;
	import bing.utils.SystemUtil;
	
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.utils.clearTimeout;
	
	import local.comm.GameRemote;
	import local.comm.GameSetting;
	import local.enum.BasicPickup;
	import local.enum.BuildingOperation;
	import local.enum.ItemType;
	import local.game.GameWorld;
	import local.model.MapGridDataModel;
	import local.model.buildings.vos.BuildingVO;
	import local.model.vos.RewardsVO;
	import local.utils.CharacterManager;
	import local.utils.CollectQueueUtil;
	import local.utils.EffectManager;
	import local.utils.PickupUtil;
	import local.views.effects.BaseMovieClipEffect;
	import local.views.effects.EffectPlacementBuilding;
	import local.views.effects.EffectPlacementDecoration;
	import local.views.effects.MapWordEffect;
	
	public class Building extends InteractiveBuilding
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
					playPlaceEffect();
					CharacterManager.instance.updateCharactersPos( this );
					//发送数据
					ro.getOperation("buy").send( buildingVO.shopItemId , nodeX,nodeZ );
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
					playPlaceEffect();
					CharacterManager.instance.updateCharactersPos( this );
					//发送数据
					ro.getOperation("move").send( buildingVO.id , nodeX,nodeZ );
					break ;
				case BuildingOperation.SELL :
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
						if(value>0)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_EXP , value,screenX,screenY-offsetY);
						this.buildingVO = e.result as BuildingVO;
					}else{
						GameWorld.instance.removeBuildFromScene(this);
					}
					break ;
				case "build":
					break ;
				case "sell":
					this.dispose();
					 break ;
				case "stash":
					this.dispose();
					break ;
				case "rotate":
					break ;
				case "move":
					break ;
			}
		}
		
		/* 播放放置的动画*/
		protected function playPlaceEffect():void
		{
			var placementMC:MovieClip;
			var type:String = ItemType.getSumType( buildingVO.baseVO.type );
			if(type==ItemType.BUILDING){
				placementMC= new  EffectPlacementBuilding ();
			}else if(type==ItemType.DECORATION){
				placementMC= new  EffectPlacementDecoration ();
			}
			if(placementMC){
				
				var placementEffect:BaseMovieClipEffect = EffectManager.instance.createMapEffectByMC(placementMC);
				placementEffect.y = offsetY+this.screenY ;
				placementEffect.x = this.screenX;
				GameWorld.instance.effectScene.addChild(placementEffect);
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
			TweenMax.to(itemLayer, 0, {dropShadowFilter:{color:0x00ff00, alpha:1, blurX:2, blurY:2, strength:5}});
			if(stepLoading&&stepLoading.parent){
				stepLoading.parent.removeChild(stepLoading);
			}
			return true ;
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
				if(_currentRewards.coin>0)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_COIN , _currentRewards.coin,screenX,screenY-offsetY);
				if(_currentRewards.exp>0)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_EXP , _currentRewards.exp,screenX,screenY-offsetY);
				if(_currentRewards.stone>0)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_STONE , _currentRewards.stone,screenX,screenY-offsetY);
				if(_currentRewards.wood>0)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_WOOD , _currentRewards.wood,screenX,screenY-offsetY);
				if(_currentRewards.pickups){
					var len:int = _currentRewards.pickups.length ;
					for( var i:int = 0 ; i<len ; ++i){
						PickupUtil.addPickup2Wold( _currentRewards.pickups[i] , 1 ,screenX,screenY-offsetY);
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