package local.game
{
	import local.game.fish.*;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameWorld extends Sprite
	{
		public function GameWorld()
		{
			super();
			addChild( new GameBg() );
			
			addChild( new Game() );
		}
		
	}
}