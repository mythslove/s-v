package game.mvc.base
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import bing.mvc.core.Mediator;
	
	public class GameMediator extends Mediator
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
		 * @param mediatorAlias  mediator的别名
		 * @param view 视图
		 */		
		public function GameMediator( view:DisplayObjectContainer)
		{
			super(view);
			this.context.registerMeditor(this);
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
			this.context.dispatchEvent(event);
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
		 * 清除资源 
		 */		
		override public function dispose():void
		{
			super.dispose();
			this.context.removeMediator( this );
		}
	}
}