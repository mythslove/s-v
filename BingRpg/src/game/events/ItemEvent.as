package game.events
{
	import flash.events.Event;
	
	import game.elements.cell.BaseItem;
	
	public class ItemEvent extends Event
	{
		public static const ADD_ITEM:String ="addItem";
		public static const REMOVE_ITEM:String = "removeItem";
		public static const CLEAR_ALL_ITEM:String = "clearAllItem";
		
		public var item:BaseItem ;
		
		public function ItemEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}