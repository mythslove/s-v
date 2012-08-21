package bing.socket.demo
{
	import bing.socket.SocketObject;
	
	import flash.events.Event;
	
	public class SocketEvent extends Event
	{
		/**
		 * 登录事件 
		 */		
		public static const LOGIN:String = "login";
		
		/**
		 * 房间事件 
		 */		
		public static const ROOM:String = "room";
		
		public var sonType:int ;
		public var data:SocketObject;
		
		public function SocketEvent( type:String , sonType:int , body:SocketObject )
		{
			super(type, false, false);
			this.sonType = sonType ;
			this.data = body ;
		}
	}
}