package local.game.elements
{
	import bing.amf3.ResultEvent;
	import bing.utils.SystemUtil;
	
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import local.enum.AvatarAction;
	import local.enum.BuildingStatus;
	import local.enum.MouseStatus;
	import local.events.GameTimeEvent;
	import local.game.GameWorld;
	import local.model.PlayerModel;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CharacterManager;
	import local.utils.CollectQueueUtil;
	import local.utils.GameTimer;
	import local.utils.MouseManager;
	import local.utils.PopUpManager;
	import local.views.CenterViewContainer;
	import local.views.effects.MapWordEffect;
	import local.views.loading.BuildingExecuteLoading;
	import local.views.pickup.BuildCompleteMaterialPopUp;
	
	/**
	 * 工厂，房子的等建筑的基类 
	 * 修建完成时最后一步，需要判断材料
	 * @author zzhanglin
	 */	
	public class Architecture extends Building
	{
		protected var _gameTimer:GameTimer ;
		
		public function Architecture(vo:BuildingVO)
		{
			super(vo);
		}
		
		//=================getter/setter=========================
		override public function get title():String{
			if(buildingVO.buildingStatus == BuildingStatus.BUILDING ){
				return baseBuildingVO.name+"("+buildingVO.currentStep+"/"+baseBuildingVO.step+")" ;
			}
			return super.title;
		}
		override public function get  description():String{
			if(buildingVO.buildingStatus == BuildingStatus.BUILDING )
			{
				if(buildingVO.currentStep==baseBuildingVO.step){
					return "Click to build complete" ;
				}
				return "Click to build (cost "+baseBuildingVO["buildWood"]+" Wood "+baseBuildingVO["buildStone"]+" Stone)" ;
			}
			else if( buildingVO.buildingStatus==BuildingStatus.HARVEST)
			{
				return "Click to collection" ;
			}
			return super.description;
		}
		override public function get isCanControl():Boolean{
			if(buildingVO.buildingStatus == BuildingStatus.BUILDING ||  buildingVO.buildingStatus==BuildingStatus.HARVEST) return false ;
			return true;
		}
		//=================getter/setter=========================
		
		
		override protected function addedToStageHandler(e:Event):void
		{
			if(this.buildingVO.buildingStatus==BuildingStatus.BUILDING){
				this.showBuildStatus();
			}else{
				super.addedToStageHandler(e);
			}
		}
		
		override public function recoverStatus():void
		{
			if(buildingVO.buildingStatus==BuildingStatus.PRODUCT){
				this.createGameTimer( buildingVO.statusTime );
			}else if( buildingVO.buildingStatus==BuildingStatus.HARVEST){
				this.showCollectionStatus() ;
			}
		}
		
		override public function onClick():void
		{
			//减能量
			if(PlayerModel.instance.me.energy<1){
				var effect:MapWordEffect = new MapWordEffect("You don't have enough Energy!");
				GameWorld.instance.addEffect(effect,screenX,screenY);
			}else{
				super.onClick();
				this.showStep( buildingVO.currentStep,baseBuildingVO["step"]);
			}
		}
		
		override public function onMouseOver():void
		{
			super.onMouseOver();
			if(buildingVO.buildingStatus == BuildingStatus.BUILDING ){
				MouseManager.instance.mouseStatus = MouseStatus.BUILD_BUILDING ;
			}else if( buildingVO.buildingStatus==BuildingStatus.HARVEST){
				MouseManager.instance.mouseStatus = MouseStatus.EARN_COIN ;
			}
		}
		
		override protected function onResultHandler( e:ResultEvent ):void
		{
			SystemUtil.debug(e.service+"."+e.method , e.result);
			super.onResultHandler(e);
			switch( e.method)
			{
				case "buy":
					this.showBuildStatus() ;
					break;
				case "earn": //收获
					this.enable = false ;
					if(e.result){
						_executeBack = true ;
						this.showPickup();
					}else{
						this.selectedStatus(false);
						CollectQueueUtil.instance.nextBuilding();
					}
					break ;
				case "build": //修建
					this.enable=false ;
					if(e.result){
						_executeBack = true ;
						this.buildingVO = e.result as BuildingVO ;
						this.showPickup();
					}else{
						this.selectedStatus(false);
						CollectQueueUtil.instance.nextBuilding();
					}
					break ;
			}
		}
		
		/*开始生产*/
		protected function startProduct():void
		{
			PlayerModel.instance.me.rank+=buildingVO.baseVO.rank ;
			CenterViewContainer.instance.topBar.updateRank();
			if(baseBuildingVO.hasOwnProperty("earnTime") && int(baseBuildingVO["earnTime"]>0))
			{
				this.buildingVO.buildingStatus=BuildingStatus.PRODUCT ;
				this.createGameTimer(  int(baseBuildingVO["earnTime"]) ) ;
			}
		}
		
		override public function execute():Boolean
		{
			if(executeReduceEnergy())
			{
				super.execute();
				if( buildingVO.buildingStatus==BuildingStatus.BUILDING)
				{
					if(buildingVO.currentStep<buildingVO.baseVO.step)
					{
						//判断石头和木头
						var effect:MapWordEffect ;
						if(PlayerModel.instance.me.wood<baseBuildingVO["buildWood"]){
							effect = new MapWordEffect("You don't have enough Wood!");
							GameWorld.instance.addEffect(effect,screenX,screenY);
							CollectQueueUtil.instance.nextBuilding();
							return false;
						}else if(PlayerModel.instance.me.stone<baseBuildingVO["buildStone"]){
							effect = new MapWordEffect("You don't have enough Stone!");
							GameWorld.instance.addEffect(effect,screenX,screenY);
							CollectQueueUtil.instance.nextBuilding();
							return false;
						}
						ro.getOperation("build").send(buildingVO.id , buildingVO.currentStep );
						CharacterManager.instance.hero.gotoAndPlay(AvatarAction.CONSTRUCT);
						this.showBuildEffect() ;
						_timeoutFlag = false ;
						_timeoutId = setTimeout( timeoutHandler , 3000 );
						GameWorld.instance.effectScene.addChild( BuildingExecuteLoading.getInstance(screenX,screenY-itemLayer.height).setTime(4000));
					}
					else if(buildingVO.currentStep==buildingVO.baseVO.step && baseBuildingVO.hasOwnProperty("materials"))
					{
						if( baseBuildingVO["materials"] ){
							//弹出判断材料的窗口
							var buildComPopup:BuildCompleteMaterialPopUp = new BuildCompleteMaterialPopUp(this);
							PopUpManager.instance.addQueuePopUp( buildComPopup);
						}else{
							//直接发送完成
							this.sendBuildComplete();
						}
						//跳到队列的下一个执行
						CollectQueueUtil.instance.nextBuilding(); 
					}
					return false ;
				}
				else if( buildingVO.buildingStatus==BuildingStatus.PRODUCT)
				{
					
				}
				else if( buildingVO.buildingStatus==BuildingStatus.HARVEST)
				{
					//收获
					ro.getOperation("earn").send(buildingVO.id );
					CharacterManager.instance.hero.gotoAndPlay(AvatarAction.COLLECT);
					_timeoutFlag = false ;
					_timeoutId = setTimeout( timeoutHandler , 3000 );
					GameWorld.instance.effectScene.addChild( BuildingExecuteLoading.getInstance(screenX,screenY-itemLayer.height).setTime(4000));
				}
			}
			return true ;
		}
		
		/**
		 * 发送建造完成的消息到服务器 
		 */		
		public function sendBuildComplete():void{
			buildingVO.buildingStatus=BuildingStatus.NONE ;
			ro.getOperation("build").send(buildingVO.id , baseBuildingVO.step );
		}
		
		/*不断执行，更新*/
		override public function update():void
		{
			super.update();
			if(_gameTimer) _gameTimer.update();
		}
		
		/*显示收藏状态*/
		protected function showCollectionStatus():void
		{
			
		}
		
		//==============计时器================================
		/*清除计时器*/
		protected function clearGameTimer():void
		{
			if(_gameTimer){
				_gameTimer.removeEventListener( GameTimeEvent.TIME_OVER , gameTimerHandler );
				_gameTimer = null ;
			}
		}
		/*创建计时器*/
		protected function createGameTimer( duration:int ):void
		{
			if(_gameTimer) clearGameTimer(); //先清除上一个计时器
			_gameTimer = new GameTimer( duration );
			_gameTimer.removeEventListener( GameTimeEvent.TIME_OVER , gameTimerHandler );
		}
		/*计时完成*/
		protected function gameTimerHandler( e:GameTimeEvent):void
		{
			if( buildingVO.buildingStatus==BuildingStatus.PRODUCT)
			{
				clearGameTimer(); //清除计时器
				buildingVO.buildingStatus=BuildingStatus.HARVEST ; //可收获
				this.showCollectionStatus();//显示收获状态
			}
		}
		
		//===============计时器end==============================
		
		override public function dispose():void
		{
			super.dispose();
			if(_gameTimer){
				_gameTimer.removeEventListener( GameTimeEvent.TIME_OVER , gameTimerHandler );
				_gameTimer = null ;
			}
		}
	}
}