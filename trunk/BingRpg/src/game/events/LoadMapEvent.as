package game.events
{
	import flash.events.Event;
	
	/**
	 * 加载地图事件 
	 * @author zhouzhanglin
	 */	
	public class LoadMapEvent extends Event
	{
		/**
		 * 地图加载中 
		 */		
		public static const MAP_LOADING_PROGERSS:String = "mapLoadingProgress";
		/**
		 * 地图加载完成 
		 */		
		public static const MAP_LOAED:String = "mapLoaded";
		
		
		public var currentStep:int ; //当前第几步
		public var totalStep:int; //总步骤
		public var info:String =""; //文字说明
		public var progress:Number ; // 加载进度，0-1的小数
		
		public function LoadMapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}