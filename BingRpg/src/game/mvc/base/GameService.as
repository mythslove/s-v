package game.mvc.base
{
	import bing.amf3.FaultEvent;
	import bing.amf3.RemoteObject;
	import bing.utils.SystemUtil;
	
	dynamic public class GameService extends RemoteObject
	{
		public static const GATEWAY:String="http://";
		
		public function GameService(serviceName:String)
		{
			super(GATEWAY , serviceName);
			this.addEventListener(FaultEvent.FAULT , onFault );
		}
		
		private function onFault(e:FaultEvent):void 
		{
			e.stopPropagation();
			SystemUtil.debug( e.fault ); //输出错误信息
		}
		
		/**
		 * 释放资源 
		 */		
		override public function dispose():void 
		{
			super.dispose();
			this.removeEventListener(FaultEvent.FAULT , onFault );
		}
	}
}