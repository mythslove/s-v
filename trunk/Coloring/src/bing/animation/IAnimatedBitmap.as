package bing.animation
{
	import flash.display.BitmapData;
	import flash.events.IEventDispatcher;

	/**
	 * 一个动作播放完成  
	 */	
	[Event(name="animationComplete",type="bing.animation.AnimationEvent")]
	
	/**
	 * 接口：循环播放的动画
	 * @author zhouzhanglin
	 * @date 2010/8/29
	 */
	public interface IAnimatedBitmap extends IEventDispatcher
	{
		/**
		 * 从某一帧开始播放 
		 * @param frame   -1表示接着原来的地方播放
		 */		
		function start( frame:int=-1 ):void ;
		
		/**
		 *  返回当前动作已经播放到了第几帧
		 */		
		function get currentFrame():int ;
		
		/**
		 *  返回当前动作的总帧数
		 */		
		function get totalFrame():int ;
		
		/**
		 * 当前是的BitmapData 
		 */		
		function get animationBmd():BitmapData ;
		
		/**
		 * 动作的循环次数 
		 * @param value
		 */		
		function set cycleTime( value:int ):void
		function get cycleTime():int ;
		
		/**
		 * 不断的播放，需要在enterFrame中不断调用 
		 * @param actionName 动作名称
		 */		
		function playAction( actionName:String ):void
			
		/**
		 * 当前的动作名称
		 */		
		function get actionName():String ;
		
		/**
		 * 所有的动作集合
		 */		
		function get actions():Vector.<ActionVO>;
			
		/**
		 * 播放的速率 
		 * @param value
		 */		
		function set rate( value:int ):void ;
		function get rate():int ;
		
		/**
		 * 停止动画 
		 * @return 
		 */		
		function stopAni():void;
		
		function dispose():void;
	}
}