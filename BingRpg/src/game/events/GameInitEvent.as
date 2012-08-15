package game.events
{
	import flash.events.Event;
	/**
	 * 游戏初始化配置和资源加载事件 
	 * @author zzhanglin
	 */	
	public class GameInitEvent extends Event
	{
		/**
		 * ConfigXML加载进度 
		 */		
		public static const CONFIG_XML_LOADING:String = "configXMLLoading";
		/**
		 * ConfigXML加载完成 
		 */		
		public static const CONFIG_XML_LOADED:String = "configXMLLoaded";
		/**
		 * UISWF加载完成 
		 */		
		public static const UI_SWF_LOADED:String = "uiSwfLoaded";
		/**
		 * UISW加载进度 
		 */		
		public static const UI_SWF_LOADING:String = "uiSwfLoading";
		
		/**
		 * 进度 
		 */		
		public var progress:Number ;
		
		public function GameInitEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}