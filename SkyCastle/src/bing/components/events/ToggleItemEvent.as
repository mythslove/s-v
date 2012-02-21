package bing.components.events
{
	import flash.events.Event;
	
	public class ToggleItemEvent extends Event
	{
		public static const ITEM_SELECTED:String = "itemSelected";
		public var selectedName:String ;
		public var selectedIndex:int ;
		
		public function ToggleItemEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}