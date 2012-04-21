package local.events
{
	import flash.events.Event;
	
	import local.model.vos.ShopItemVO;
	/**
	 * 商店中的事件 
	 * @author zzhanglin
	 */	
	public class ShopEvent extends Event
	{
		/**
		 * 选择了一个建筑
		 */		
		public static const SELECTED_BUILDING:String = "selectedBuilding";
		
		public var selectedBuilding:ShopItemVO ;
		
		public function ShopEvent(type:String, vo:ShopItemVO = null ,  bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.selectedBuilding = vo ;
		}
	}
}