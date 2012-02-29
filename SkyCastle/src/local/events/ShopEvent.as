package local.events
{
	import flash.events.Event;
	
	import local.model.buildings.vos.BuildingVO;
	
	public class ShopEvent extends Event
	{
		/**
		 * 选择了一个建筑
		 */		
		public static const SELECTED_BUILDING:String = "selectedBuilding";
		
		public var selectedBuilding:BuildingVO ;
		
		public function ShopEvent(type:String, vo:BuildingVO = null ,  bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.selectedBuilding = vo ;
		}
	}
}