package local.map.item
{
	import local.util.GameTimer;
	import local.vo.BuildingVO;
	
	import starling.events.Event;
	
	public class Building extends BaseBuilding
	{
		public var gameTimer:GameTimer ;
		
		public function Building(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
		
		public function recoverStatus():void
		{
			
		}
		
		public function checkRoadAndIcon():void
		{
			
		}
		
		protected function buildClick():void
		{
			
		}
		protected function createGameTimer(duration:int):void
		{
			
		}
		protected function clearGameTimer():void
		{
		}
		protected function gameTimerCompleteHandler(e:Event):void
		{
			
		}
	}
}