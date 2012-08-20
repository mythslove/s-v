package game.events
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class SocketEvent extends Event
	{
		public static const ALL:String = "all";
		
		public static const LOGIN:String = "Login";
		
		public static const ROOM:String = "room";
		
		public static const GAME:String ="game";
		
		public var data:ByteArray ;
		public var len:uint  ;
		public var control:uint ; 
		public var sonType:uint ;
		public var time:uint ;
		
		public function SocketEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}