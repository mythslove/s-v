package game.events
{
	import flash.events.Event;
	
	public class HeroEvent extends Event
	{
		/**
		 * 到达目的地，用于寻路 
		 */		
		public static const ARRIVED_DESTINATION:String ="arrivedDestination";
		
		public function HeroEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}