package tool.events
{
	import flash.events.Event;
	
	import tool.local.vos.MapVO;
	
	public class MapEvent extends Event
	{
		/**
		 * 新建地图 
		 */		
		public static const NEWMAP:String = "newMap";
		/**
		 * 地图数据改变 
		 */		
		public static const MAPEVENT_CHANGE:String = "mapEventChange";
		/**
		 * 地图的offset设置改变 
		 */		
		public static const MAP_OFFSET_CHANGE:String = "mapOffsetChange";
		
		public var mapVO:MapVO ;
		
		public function MapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}