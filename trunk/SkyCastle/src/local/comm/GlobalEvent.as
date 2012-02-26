package local.comm
{
	import flash.events.Event;
	
	public class GlobalEvent extends Event
	{
		/**
		 * 场景大小变化 
		 */		
		public static const RESIZE:String = "resize";
		
		public function GlobalEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}