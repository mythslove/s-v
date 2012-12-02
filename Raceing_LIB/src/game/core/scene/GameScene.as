package game.core.scene
{
	import game.core.car.BaseCar;
	import game.core.track.BaseTrack;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameScene extends Sprite
	{
		private var _car:BaseCar ;
		private var _track:BaseTrack;
		
		public function GameScene()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE , addedHandler);
		}
		
		private function addedHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler);
			addEventListener(Event.REMOVED_FROM_STAGE , removedHandler );
		}
		
		private function removedHandler( e:Event ):void
		{
			
		}
	}
}