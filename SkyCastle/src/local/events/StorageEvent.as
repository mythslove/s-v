package local.events
{
	import flash.events.Event;
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
		
		public function StorageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}