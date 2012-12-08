package game.events
{
	import starling.events.Event;
	
	public class GameControlEvent extends Event
	{
		public static const GAME_OVER:String = "gameOver";
		public static const GAME_SUCCESS:String = "gameSuccess";
		
		public function GameControlEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}