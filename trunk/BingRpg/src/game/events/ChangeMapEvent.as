package game.events
{
	import flash.events.Event;
	
	/**
	 * 切换地图事件 
	 * @author zhouzhanglin
	 */	
	public class ChangeMapEvent extends Event
	{
		/**
		 * 切换地图开始 
		 */		
		public static const CHANGE_MAP_START:String = "changeMapStart";
		/**
		 * 切换地图结束 
		 */		
		public static const CHANGE_MAP_OVER:String =  "changeMapOver";
		
		public var mapId:int ;
		
		public function ChangeMapEvent(type:String, mapId:int=0 ,  bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			if(mapId>0)
			{
				this.mapId = mapId ;
			}
		}
	}
}