package tool.comm
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class GlobalDispatcher extends EventDispatcher
	{
		private static var _instance:GlobalDispatcher ;
		public static function get instance():GlobalDispatcher
		{
			if(!_instance) _instance = new GlobalDispatcher();
			return _instance ;
		}
	}
}