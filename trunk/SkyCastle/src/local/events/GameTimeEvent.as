package local.events
{
	import flash.events.Event;
	/**
	 *  游戏倒计时完成 
	 * @author zzhanglin
	 */	
	public class GameTimeEvent extends Event
	{
		public static const TIME_OVER:String="timeOver";
		
		public function GameTimeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}