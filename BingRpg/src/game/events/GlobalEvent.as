package game.events
{
	import flash.events.Event;
	
	public class GlobalEvent extends Event
	{
		/**
		 * 显示游戏界面 
		 */		
		public static const SHOW_VIEWS:String = "showViews";
		public function GlobalEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}