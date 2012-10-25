package local.map.item
{
	import bing.starling.iso.SIsoObject;
	
	import local.comm.GameSetting;
	
	import starling.events.Event;
	
	
	public class BaseMapObject extends SIsoObject
	{
		public function BaseMapObject(xSpan:int=1, zSpan:int=1)
		{
			super(GameSetting.GRID_SIZE, xSpan, zSpan);
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