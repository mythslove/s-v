package comm
{
	import flash.events.Event;
	
	public class GlobalEvent extends Event
	{
		public static const RESIZE:String = "resize";
		
		public function GlobalEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}