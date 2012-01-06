package comm
{
	import flash.events.Event;
	
	public class GlobalEvent extends Event
	{
		public function GlobalEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}