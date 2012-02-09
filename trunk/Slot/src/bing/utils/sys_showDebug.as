package bing.utils
{
	import flash.net.LocalConnection;

	/** 是否打印debug */
	public var sys_showDebug:Boolean = true ;
	
	/**
	 *强制执行垃圾回收 
	 */		
	public function sys_GC():void{
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
	public function sys_debug( ...params):void 
	{
		if(sys_showDebug)	trace(params);
	}
}