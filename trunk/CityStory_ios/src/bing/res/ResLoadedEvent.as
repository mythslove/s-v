package bing.res
{
	import flash.events.Event;
	/**
	 * 资源下载完成事件 
	 * <b>事件类型为resVO中的name</b>
	 * @author zhouzhanglin
	 */	
	public class ResLoadedEvent extends Event
	{
		public var resVO:ResVO ;
		
		public function ResLoadedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}