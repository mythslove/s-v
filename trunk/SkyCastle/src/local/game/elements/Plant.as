package local.game.elements
{
	import bing.amf3.ResultEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import local.enum.AvatarAction;
	import local.enum.BasicPickup;
	import local.enum.BuildingStatus;
	import local.enum.QuestType;
	import local.events.GameTimeEvent;
	import local.game.GameWorld;
	import local.model.QuestModel;
	import local.model.buildings.vos.BasePlantVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CharacterManager;
	import local.utils.GameTimer;
	import local.utils.PickupUtil;
	import local.views.loading.BuildingExecuteLoading;

	/**
	 * 种植类建筑 
	 * @author zzhanglin
	 */	
	public class Plant extends Building
	{
		protected var _gameTimer:GameTimer ;
		protected var _buildingFlag:Sprite; //建筑的状态标志，如可以收获，损坏
		private var _gameTimerTick:int ;
		
		public function Plant(vo:BuildingVO)
		{
			super(vo);
		}
		//=================getter/setter=========================
		/** 获取此建筑的基础VO */
		public function get basePlantVO():BasePlantVO{
			return buildingVO.baseVO as BasePlantVO ;
		}
		override public function get isCanControl():Boolean{
			if(buildingVO.buildingStatus==BuildingStatus.HARVEST) return false ;
			return true;
		}
		override public function get description():String
		{
			if(buildingVO.buildingStatus==BuildingStatus.HARVEST) return "Click to collect this item." ;
			else if(_gameTimer) return "Product: "+ Math.floor(_gameTimer.duration/60) +"min" ;
			return "";
		}
		//=================getter/setter=========================
		override public function recoverStatus():void
		{
			if(buildingVO.buildingStatus==BuildingStatus.PRODUCT){
				this.createGameTimer( buildingVO.statusTime );
			}else if( buildingVO.buildingStatus==BuildingStatus.HARVEST){
				this.showCollectionStatus() ;
			}
		}
		
		override protected function resLoadedHandler(e:Event):void
		{
			super.resLoadedHandler(e);
			if( buildingVO.buildingStatus==BuildingStatus.HARVEST && _skin ){
				_skin.gotoAndStop(2);
			}
		}
		
		override public function onClick():void
		{
			switch( buildingVO.buildingStatus)
			{
				case BuildingStatus.PRODUCT:
					//弹出grow Instantly窗口
					break ;
				case BuildingStatus.HARVEST:
					super.onClick();
					break ;
			}
		}
		
		public function growInstantly():void
		{
			buildingVO.buildingStatus=BuildingStatus.PRODUCT ;
			this.createGameTimer(0);
		}
		
		override protected function onResultHandler( e:ResultEvent ):void
		{
			super.onResultHandler(e);
			switch( e.method)
			{
				case "buy":
					this.startProduct() ;
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
			}
		}
		
		/*开始生产*/
		protected function startProduct():void{
			this.buildingVO.buildingStatus=BuildingStatus.PRODUCT ;
			this.createGameTimer( basePlantVO.earnTime) ;
		}
		
		
		
		/*显示收获状态*/
		protected function showCollectionStatus():void{
//			if(!_buildingFlag) {
//				_buildingFlag = new BuildingCollectionFlag();
//				_buildingFlag.y = offsetY ;
//			}
//			if(_skin) _skin.gotoAndStop(2);
//			addChild( _buildingFlag );
		}
		
		
		/*不断执行，更新*/
		override public function update():void
		{
			super.update();
			if(_gameTimer) 
			{
				++_gameTimerTick ;
				if(_gameTimerTick>=24){
					_gameTimer.update();
					_gameTimerTick = 0 ;
				}
			}
		}
		
		override public function execute():Boolean
		{
			if(executeReduceEnergy())
			{
				super.execute();
				if( buildingVO.buildingStatus==BuildingStatus.HARVEST)
				{
					//收获
					ro.getOperation("collect").send(buildingVO.id );
					CharacterManager.instance.hero.gotoAndPlay(AvatarAction.DIG);
					_timeoutFlag = false ;
					_timeoutId = setTimeout( timeoutHandler , 3000 );
					GameWorld.instance.effectScene.addChild( BuildingExecuteLoading.getInstance(screenX,screenY-itemLayer.height).setTime(4000));
				}
			}
			return true ;
		}
		
		
		
		
		
		/**
		 * 掉物品 ，并接着下一个收集
		 */		
		override public function showPickup():void
		{
			if( _timeoutFlag && _executeBack)
			{
				clearEffect();
				var value:int = basePlantVO.earnCoin ;
				if(value>0) PickupUtil.addPickup2Wold(BasicPickup.PICKUP_COIN ,  value , screenX,screenY+offsetY*0.5);
				//特殊物品
				showRewardsPickup();
				//==========================
				_timeoutFlag=false ;
				_executeBack = false ;
				_currentRewards = null ;
				super.showPickup();
				
				//统计 quest
				QuestModel.instance.updateQuests( QuestType.COLLECT_NUM );
				
				//从世界中删除
				GameWorld.instance.removeBuildFromScene(this);
				this.dispose();
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
		}
	}
}