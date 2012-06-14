package bing.amf3  
{
	import flash.events.Event;	

	public final class FaultEvent extends Event 
	{
		/**
		 * 此对象中包括,service,method,message 
		 */		
		public var faultObj : Object;
		
		public static const FAULT : String = "amfFault";

		public function FaultEvent(type : String)
		{
			super(type, false, false);
		}
		
	}
}