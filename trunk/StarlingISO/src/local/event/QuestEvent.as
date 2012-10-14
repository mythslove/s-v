package local.event
{
	import flash.events.Event;
	
	import local.vo.QuestVO;

	/**
	 * 任务事件 
	 * @author zhouzhanglin
	 */	
	public class QuestEvent extends Event
	{
		/** 任务完成 */
		public static const QUEST_COMPLETE:String = "questComplete";
		
		public var vo:QuestVO ;
		
		public function QuestEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}