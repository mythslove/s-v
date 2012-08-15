package game.elements.items.interfaces
{
	import flash.events.IEventDispatcher;
	import flash.geom.Point;

	/**
	 * 可移动的对象 
	 * @author zhouzhanglin
	 */	
	public interface IMoveable extends IEventDispatcher
	{
		/**
		 * 移动到一个点 
		 * @param point
		 * @return 
		 */		
		function moveToPoint( point:Point):Boolean ;
		
		/**
		 * 通过点来移动 
		 * @param roads
		 */		
		function moveByRoads( roads:Array ):void ;
		
		/**
		 * 寻路并移动 
		 * @param px
		 * @param py
		 * @return 是否有路径
		 */		
		function findAndMove( px:Number,py:Number ):Boolean ;
		
		/**
		 * 移动 
		 */		
		function move():void ;
		
		/**
		 * 停止移动 
		 */		
		function stopMove():void ;
	}
}