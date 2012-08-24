package local.comm
{
	import starling.events.EventDispatcher;
	
	/**
	 * 处理  全局事件
	 * @author zhouzhanglin
	 */	
	public class GlobalDispatcher extends EventDispatcher
	{
		private static var _instance:GlobalDispatcher ;
		public static function get instance():GlobalDispatcher
		{
			if(!_instance) _instance = new GlobalDispatcher();
			return _instance; 
		}
	}
}