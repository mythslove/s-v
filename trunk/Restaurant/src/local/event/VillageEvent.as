package local.event
{
	import flash.events.Event;
	
	public class VillageEvent extends Event
	{
		/** 已经保存农场的信息 */
		public static const SAVED_VILLAGE:String = "savedVillage"; 
		/** 已经读取农场的信息 */
		public static const READED_VILLAGE:String = "readedVillage";
		/** 是一个新的农场 */
		public static const NEW_VILLAGE:String = "newVillage"; 
		
		public function VillageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}