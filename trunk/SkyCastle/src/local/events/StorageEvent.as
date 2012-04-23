package local.events
{
	import flash.events.Event;
	
	import local.model.vos.StorageItemVO;

	/**
	 * 收藏箱的事件 
	 * @author zzhanglin
	 */	
	public class StorageEvent extends Event
	{
		/**
		 * 获取了所有的收藏箱建筑
		 */		
		public static const GET_STROAGE_ITEMS:String = "getStroageItems";
		/**
		 * 选择了一个建筑
		 */		
		public static const SELECTED_BUILDING:String = "selectedBuilding";
		
		public var selectedBuilding:StorageItemVO ;
		
		public function StorageEvent(type:String, vo:StorageItemVO = null ,  bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.selectedBuilding = vo ;
		}
	}
}