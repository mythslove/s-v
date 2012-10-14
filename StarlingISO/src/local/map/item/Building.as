package local.map.item
{
	import flash.events.Event;
	
	import local.util.GameTimer;
	import local.vo.BuildingVO;
	
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
		protected function gameTimerCompleteHandler(e:flash.events.Event):void
		{
			
		}
	}
}