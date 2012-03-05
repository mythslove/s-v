package events
{
	import flash.events.Event;
	
	import map.MapScene;
	
	public class WorldSettingEvent extends Event
	{
		public static const ADD_LAYER:String = "addLayer";
		public static const DELETE_LAYER:String = "deleteLayer";
		public var scene:MapScene;
		
		public static const ZOOM:String=  "zoom";
		public var zoom:Number;
		
		public static const OFFSEX:String = "offsetX";
		public static const OFFSEY:String = "offsetY";
		public var offsetX:Number;
		public var offsetY:Number;
		
		public function WorldSettingEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}