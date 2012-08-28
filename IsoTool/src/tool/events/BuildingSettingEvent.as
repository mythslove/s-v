package tool.events
{
	import flash.events.Event;
	
	import tool.local.vos.BitmapAnimResVO;
	
	public class BuildingSettingEvent extends Event
	{
		public static const CHANGE:String = "change";
		public static const DELETE:String=  "delete";
		
		public var vo:BitmapAnimResVO ;
		
		public function BuildingSettingEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}