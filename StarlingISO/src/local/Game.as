package local
{
	import bing.starling.iso.SIsoGrid;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		public function Game()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler( e:Event ):void
		{
			var grid:SIsoGrid = new SIsoGrid(10,10,50);
			addChild( grid );
		}
	}
}