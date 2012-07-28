package local.events
{
	import flash.events.Event;
	
	import local.model.vos.QuestVO;
	/**
	 * 任务的相关事件 
	 * @author zhouzhanglin
	 */	
	public class QuestEvent extends Event
	{
		/** 获取到了当前的任务列表 */
		public static const GET_QUEST_LIST:String = "getQuestList";
		
		/** 加载任务配置 */
		public static const LOADED_QUEST_CONFIG:String = "loadedQuestConfig";
		
		/** 获取到了完成的任务列表 */
		public static const GET_COMPLETED_QUESTS:String = "getCompletedQuests";
		
		/** 有任务完成*/
		public static const QUEST_COMPLETED:String = "questCompleted";
		/** 完成的任务id*/
		public var completedQuestId:String ; 
		
		public var newQuests:Vector.<QuestVO> ;//新的quests
		
		public function QuestEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}