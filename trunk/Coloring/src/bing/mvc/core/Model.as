package bing.mvc.core
{
	import flash.events.Event;
	
	import bing.mvc.interfaces.IModel;
	
	public class Model implements IModel
	{
		public function Model()
		{
		}
		
		public function dispose():void
		{
		}
		
		/**
		 * 侦听全局事件 
		 * @param type
		 * @param callFun
		 */		
		public function addContextListener( type:String , callFun:Function ):void
		{
		}
		
		/**
		 * 抛出全局事件 
		 * @param event
		 */		
		public function dispatchContextEvent( event:Event):void
		{
		}
		
		/**
		 * 移除全局侦听 
		 * @param type
		 * @param callFun
		 */		
		public function removeContextListener(type:String , callFun:Function):void 
		{
			
		}
	}
}