package map
{
	import bing.iso.IsoObject;
	
	import comm.GameSetting;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import vos.BuildingVO;
	
	public class Building extends IsoObject
	{
		public var vo:BuildingVO ;
		public var itemLayer:Sprite;
		
		public function Building(vo:BuildingVO)
		{
			super(GameSetting.GRID_SIZE, 1, 1);
			this.vo = vo ;
			addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			
			itemLayer = new Sprite();
			addChild(itemLayer);
		}
		
		protected function addedToStageHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			addEventListener(Event.REMOVED_FROM_STAGE , removedFromStageHandler );
			
		}
		
		protected function removedFromStageHandler(e:Event):void
		{
			
		}
	}
}