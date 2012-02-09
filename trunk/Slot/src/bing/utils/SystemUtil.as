package bing.utils
{
	import flash.net.LocalConnection;

	public class SystemUtil
	{
		/** 是否打印debug */
		public static var showDebug:Boolean = true ;
		
		/**
		 *强制执行垃圾回收 
		 */		
		public static function GC():void{
			try{
				(new LocalConnection).connect("foo");
				(new LocalConnection).connect("foo");
			}catch(e:Error){
				//trace("GC_totalMemory: "+System.totalMemory);
			}
		}
		
		/**
		 * trace信息 
		 * @param params
		 */		
		public static function debug( ...params):void 
		{
			if(showDebug)	trace(params);
		}
	}
}