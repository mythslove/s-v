package local.game.elements
{
	import bing.amf3.ResultEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import local.comm.GameSetting;
	import local.enum.AvatarAction;
	import local.enum.BuildingStatus;
	import local.enum.MouseStatus;
	import local.events.GameTimeEvent;
	import local.game.GameWorld;
	import local.model.PlayerModel;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CharacterManager;
	import local.utils.CollectQueueUtil;
	import local.utils.EffectManager;
	import local.utils.GameTimer;
	import local.utils.MouseManager;
	import local.utils.PopUpManager;
	import local.utils.ResourceUtil;
	import local.utils.SoundManager;
	import local.views.effects.BitmapMovieClip;
	import local.views.effects.BuildingCollectionFlag;
	import local.views.effects.MapWordEffect;
	import local.views.loading.BaseStepLoading;
	import local.views.loading.BuildingExecuteLoading;
	import local.views.loading.BuildingProductLoading;
	import local.views.pickup.BuildCompleteMaterialPopUp;
	
	/**
	 * 工厂，房子的等建筑的基类 
	 * 修建完成时最后一步，需要判断材料
	 * @author zzhanglin
	 */	
	public class Architecture extends Building
	{
		protected var _gameTimer:GameTimer ;
		protected var _buildingFlag:Sprite; //建筑的状态标志，如可以收获，损坏
		protected var _anim:BitmapMovieClip ;
		private var _gameTimerTick:int ;
		
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
		
		/** 步数loading */
		override public function get stepLoading():BaseStepLoading
		{
			if(!_stepLoading) _stepLoading=new BuildingProductLoading();
			return _stepLoading;
		}
		
		override public function onClick():void
		{
			switch( buildingVO.buildingStatus)
			{
				case BuildingStatus.BUILDING:
					if(buildingVO.currentStep<buildingVO.baseVO.step){
						super.onClick();
					}
					else if(buildingVO.currentStep==buildingVO.baseVO.step)
					{
						if(baseBuildingVO.hasOwnProperty("materials"))
						{
							_timeoutFlag = true ;
							if( baseBuildingVO["materials"] ){
								//弹出判断材料的窗口
								var buildComPopup:BuildCompleteMaterialPopUp = new BuildCompleteMaterialPopUp(this);
								PopUpManager.instance.addQueuePopUp( buildComPopup);
							}else{
								//直接发送完成
								this.sendBuildComplete();
							}
						}
					}
					break ;
				case BuildingStatus.HARVEST:
					super.onClick();
					break ;
			}
		}
		
		override public function onMouseOver():void
		{
			super.onMouseOver();
			if(buildingVO.buildingStatus == BuildingStatus.BUILDING ){
				MouseManager.instance.mouseStatus = MouseStatus.BUILD_BUILDING ;
			}
		}
		
		override protected function onResultHandler( e:ResultEvent ):void
		{
			super.onResultHandler(e);
			switch( e.method)
			{
				case "buy":
					this.showBuildStatus() ;
					break;
				case "collect": //收获
					this.enable = false ;
					if(e.result){
						_executeBack = true ;
						this.showPickup();
						if(_buildingFlag && _buildingFlag.parent) 
							removeChild(_buildingFlag);
					}
					break ;
				case "build": //修建
					this.enable=false ;
					if(e.result){
						_executeBack = true ;
						this.buildingVO = e.result as BuildingVO ;
						this.showPickup();
					}
					break ;
				case "placeStash":
					//开始生产
					if(baseBuildingVO.hasOwnProperty("earnTime") && int(baseBuildingVO["earnTime"])>0 )
					{
						buildingVO.buildingStatus=BuildingStatus.PRODUCT ;
						createGameTimer( int(baseBuildingVO["earnTime"]) );
					}
					break ;
			}
		}
		
		/*开始生产*/
		protected function startProduct():void
		{
			if(baseBuildingVO.hasOwnProperty("earnTime") && int(baseBuildingVO["earnTime"]>0))
			{
				this.buildingVO.buildingStatus=BuildingStatus.PRODUCT ;
				this.createGameTimer(  int(baseBuildingVO["earnTime"]) ) ;
			}
		}
		
		override protected function resLoadedHandler( e:Event ):void
		{
			super.resLoadedHandler(e);
			//自身动画
			var animMC:MovieClip = ResourceUtil.instance.getInstanceByClassName(baseBuildingVO.resId,baseBuildingVO.alias+"_Anim") as MovieClip;
			if(animMC && animMC.totalFrames>1){
				_anim =  EffectManager.instance.createBmpAnimByMC(animMC) ;
				itemLayer.addChild(_anim);
				offsetY = _skin.getBounds(_skin).y-GameSetting.GRID_SIZE ;
				var tempY:int = animMC.getBounds(animMC).y;
				offsetY = offsetY>tempY? tempY:offsetY ;
			}
			if(buildingVO.buildingStatus==BuildingStatus.HARVEST && _buildingFlag){
				_buildingFlag.y = offsetY ;
				_buildingFlag.visible = true ;
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
						SoundManager.instance.playSoundBuild();
						this.showBuildEffect() ;
						_timeoutFlag = false ;
						_timeoutId = setTimeout( timeoutHandler , 2000 );
						GameWorld.instance.effectScene.addChild( BuildingExecuteLoading.getInstance(screenX,screenY-itemLayer.height).setTime(3000));
					}
					return false ;
				}
				else if( buildingVO.buildingStatus==BuildingStatus.HARVEST)
				{
					//收获
					ro.getOperation("collect").send(buildingVO.id );
					CharacterManager.instance.hero.gotoAndPlay(AvatarAction.COLLECT);
					SoundManager.instance.playSoundCollect();
					_timeoutFlag = false ;
					_timeoutId = setTimeout( timeoutHandler , 2000 );
					GameWorld.instance.effectScene.addChild( BuildingExecuteLoading.getInstance(screenX,screenY-itemLayer.height).setTime(3000));
				}
			}
			return true ;
		}
		
		/**
		 * 发送建造完成的消息到服务器 
		 */		
		public function sendBuildComplete():void{
			ro.getOperation("build").send(buildingVO.id , baseBuildingVO.step );
		}
		
		/*不断执行，更新*/
		override public function update():void
		{
			if(visible)
			{
				if(_anim && _anim.update() ){
					var rect:Rectangle = _anim.getBound();
					_anim.x = rect.x ;
					_anim.y = rect.y;
				}
				if(_gameTimer) 
				{
					++_gameTimerTick ;
					if(_gameTimerTick>=12){
						_gameTimer.update();
						_gameTimerTick = 0 ;
					}
				}
			}
		}
		
		/*显示收获状态*/
		protected function showCollectionStatus():void{
			if(!_buildingFlag) {
				_buildingFlag = new BuildingCollectionFlag();
			}
			_buildingFlag.y = offsetY ;
			addChild( _buildingFlag );
			if(itemLayer.numChildren==0){
				_buildingFlag.visible=false;
			}
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
			_gameTimer.addEventListener( GameTimeEvent.TIME_OVER , gameTimerHandler );
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
			if(_gameTimer) clearGameTimer();
			_buildingFlag = null ;
			if(_anim){
				_anim.dispose();
				_anim = null ;
			}
		}
	}
}