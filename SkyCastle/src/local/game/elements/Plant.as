package local.game.elements
{
	import flash.display.Sprite;
	
	import local.enum.BuildingStatus;
	import local.events.GameTimeEvent;
	import local.model.buildings.vos.BasePlantVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.GameTimer;

	/**
	 * 种植类建筑 
	 * @author zzhanglin
	 */	
	public class Plant extends Building
	{
		protected var _gameTimer:GameTimer ;
		protected var _buildingFlag:Sprite; //建筑的状态标志，如可以收获，损坏
		
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
		//=================getter/setter=========================
		override public function recoverStatus():void
		{
			if(buildingVO.buildingStatus==BuildingStatus.PRODUCT){
				this.createGameTimer( buildingVO.statusTime );
			}else if( buildingVO.buildingStatus==BuildingStatus.HARVEST){
				this.showCollectionStatus() ;
			}
		}
		
		
		/*显示收获状态*/
		protected function showCollectionStatus():void{
//			if(!_buildingFlag) {
//				_buildingFlag = new BuildingCollectionFlag();
//				_buildingFlag.y = offsetY ;
//			}
//			addChild( _buildingFlag );
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
	}
}