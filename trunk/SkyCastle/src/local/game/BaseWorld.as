package local.game
{
	import bing.iso.IsoWorld;
	
	import flash.events.Event;
	
	import local.comm.GameSetting;
	
	public class BaseWorld extends IsoWorld
	{
		public function BaseWorld()
		{
			super(GameSetting.MAP_WIDTH, GameSetting.MAX_HEIGHT , GameSetting.GRID_X, GameSetting.GRID_Z, GameSetting.GRID_SIZE);
			mouseEnabled = false ;
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
		}
		
		public function zoom( value:Number =1 ):void
		{
			
		}
	}
}