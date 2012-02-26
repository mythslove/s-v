package bing.res
{
	import flash.events.Event;
	
	public class ResProgressEvent extends Event
	{
		public static const RES_LOAD_PROGRESS:String="resLoadProgress";
		public var total:int ; //总共的
		public var loaded:int ; //已经下载完成的
		public var name:String ;
		
		public function ResProgressEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}