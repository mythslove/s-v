package local
{
	import bing.starling.iso.SIsoWorld;
	
	import local.comm.GameSetting;
	
	import starling.display.*;
	import starling.events.Event;
	
	public class MainGame extends SIsoWorld
	{
		
		public function MainGame()
		{
			super( GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE );
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			var world:GameWorld = new GameWorld();
			addChild( world );
		}
	}
}