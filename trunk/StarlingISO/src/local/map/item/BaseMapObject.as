package local.map.item
{
	import bing.starling.iso.SIsoObject;
	
	import starling.events.Event;
	
	
	public class BaseMapObject extends SIsoObject
	{
		public function BaseMapObject(size:Number, xSpan:int=1, zSpan:int=1)
		{
			super(size, xSpan, zSpan);
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			showUI();
		}
		
		public function showUI():void{
			
		}
	}
}