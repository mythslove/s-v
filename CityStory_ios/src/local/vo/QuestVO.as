package local.vo
{
	public class QuestVO
	{
		public var qid:String ; //任务的id
		public var title:String ; //标题
		public var info:String ; //描述
		public var icon:String ; //icon名称 
		public var completeMsg:String ; //任务完成后的描述
		
		public var isAccept:Boolean; //是否接受任务
		public var isComplete:Boolean; //是否完成任务
		public var acceptTime:Number ; //接受任务的时间
		public var tasks:Array ; //所有的QuestItemVO 
		public var rewards:String; //完成任务后的奖励
	}
}