package bing.a3d.events
{
	import flash.events.Event;
	
	public class Scene3DEvent extends Event
	{
		public static const PROGRESS_EVENT:String = "progressEvent";
		public static const COMPLETE_EVENT:String = "completeEvent";
		public var progress:Number ;
		
		public function Scene3DEvent(type:String, progress:Number = 1, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.progress = progress ;
		}
	}
}