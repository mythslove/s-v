package local.view.control
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class ToggleBarEvent extends Event
	{
		public static const TOGGLE_CHANGE:String = "toggleChange";
		
		public var selectedButton:MovieClip ;
		public var selectedName:String ;
		
		public function ToggleBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}