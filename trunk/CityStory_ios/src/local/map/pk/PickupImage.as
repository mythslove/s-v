package local.map.pk
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class PickupImage extends Sprite
	{
		public function PickupImage( pkType:String  , value:int , compName:String = null )
		{
			super();
			mouseEnabled = mouseChildren = false ;
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
	}
}