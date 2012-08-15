package game.events
{
	import flash.events.Event;
	/**
	 * 弹出信息提示 
	 * @author zzhanglin
	 */	
	public class PopTipEvent extends Event
	{
		public function PopTipEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}