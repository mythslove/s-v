package game.mvc.base
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import bing.mvc.core.Model;
	
	public class GameModel extends Model
	{
		/**
		 * MVC上下文 
		 * @return 
		 */		
		public function get context():GameContext
		{
			return GameContext.instance;
		}
		
		/**
		 * 主容器 
		 * @return 
		 */		
		public function get contextView():DisplayObjectContainer
		{
			return context.contextView;
		}
		
		/**
		 *  构造函数
		 */		
		public function GameModel( )
		{
			this.context.registerModel ( this);
		}
		
		/**
		 * 侦听全局事件 
		 * @param type
		 * @param callFun
		 */		
		override public function addContextListener( type:String , callFun:Function ):void
		{
			this.context.addContextListener(type,callFun);
		}
		
		/**
		 * 抛出全局事件 
		 * @param event
		 */		
		override public function dispatchContextEvent( event:Event):void
		{
			this.context.dispatchContextEvent(event);
		}
		/**
		 *移除全局侦听  
		 * @param type
		 * @param callFun
		 */		
		override public function removeContextListener(type:String, callFun:Function):void
		{
			this.context.removeContextListener(type,callFun);
		}
		
		/**
		 * 释放资源 
		 */		
		override public function dispose():void
		{
			super.dispose();
			this.context.removeModel( this);
		}
	}
}