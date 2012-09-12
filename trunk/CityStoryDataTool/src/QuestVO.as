package
{
	public class QuestVO
	{
		public var qid:String=""  ; //任务的id
		public var title:String ="" ; //标题
		public var info:String =""  ; //描述
		public var icon:String =""  ; //icon名称 
		public var completeMsg:String ="" ; //任务完成后的描述
		
		public var tasks:Vector.<QuestTaskVO> ; //所有的QuestTaskVO 
		public var rewards:String ="" ; //完成任务后的奖励 , URLVariable 类型, eg :  cash=3&coin=10&exp=20&Ticket=3
		
		public var restrictLevel:int =0; //要求玩家的等级
		public var restrictQuest:String="" ; //前置quest的id
		
	}
}