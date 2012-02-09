package bing.amf3
{
	import flash.events.Event;

	public final class ResultEvent extends Event {

		public var result : Object;
		public var service:String ;
		public var method:String ;
		
		public static const RESULT : String = "amfResult";
		
		public function ResultEvent(type : String) 
		{
			super(type, false, false);
		}
	}
}