package local
{
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		public function Game()
		{
			super();
			Starling.current.stage.stageWidth  = 760;
			Starling.current.stage.stageHeight = 640;
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler( e:Event ):void
		{
//			var grid:SIsoGrid = new SIsoGrid(10,10,50);
//			addChild( grid );
			
			var img:Image = new Image( Assets.createTextureByName("starling_round") );
			addChild(img);
		}
	}
}