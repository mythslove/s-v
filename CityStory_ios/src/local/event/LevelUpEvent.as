package local.event
{
	import flash.events.Event;
	
	public class LevelUpEvent extends Event
	{
		public static const LEVEL_UP:String = "levelUp";
		public function LevelUpEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}