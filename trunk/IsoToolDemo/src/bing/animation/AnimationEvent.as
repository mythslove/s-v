package bing.animation
{
	import flash.events.Event;
	/**
	 * 动画事件 
	 * @author zhouzhanglin
	 */	
	public class AnimationEvent extends Event
	{
		/**
		 *一个动作的循环次数完成后，抛出此完成事件 
		 */		
		public static const ANIMATION_COMPLETE:String = "animationComplete";
		
		public function AnimationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}