package bing.mvc.core
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import bing.mvc.interfaces.IMediator;
	
	public class Mediator implements IMediator
	{
		private var _view:DisplayObjectContainer ;
		
		public function get view():DisplayObjectContainer
		{
			return _view ;
		}
		
		public function Mediator( view:DisplayObjectContainer )
		{
			this._view = view ;
			this._view.addEventListener(Event.ADDED_TO_STAGE , addToStage);
		}
		
		private function addToStage(e:Event):void 
		{
			this._view.removeEventListener(Event.ADDED_TO_STAGE , addToStage);
			onRegister();
		}
		
		public function onRegister():void
		{
		}
		
		
		public function dispose():void
		{
			
		}
		
		public function preRegister():void 
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