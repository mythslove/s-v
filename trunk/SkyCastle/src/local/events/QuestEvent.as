package local.events
{
	import flash.events.Event;
	
	import local.model.vos.QuestVO;
	
	public class QuestEvent extends Event
	{
		/** 获取到了任务列表 */
		public static const GET_QUEST_LIST:String = "getQuestList";
		public var newQuests:Vector.<QuestVO> ;//新的quests
		
		public function QuestEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}