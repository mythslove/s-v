package local.model.vos
{
	public class QuestVO
	{
		public var qid:int ; //任务的id
		public var title:String ; //标题
		public var info:String ; //描述
		public var icon:String ; //icon名称
		public var completeMsg:String ; //任务完成后的描述
		
		public var isAccept:Boolean; //是否接受任务
		public var isComplete:Boolean; //是否完成任务
		public var isReceive:Boolean ; //是否收到礼物
		public var acceptTime:Number ; //接受任务的时间
		public var items:Array ; //所有的QuestItemVO 
		public var rewardsVO:RewardsVO; //完成任务后的奖励
		
		public function checkComple():Boolean
		{
			if(isComplete) return true ;
			if(items){
				for each( var itemVO:QuestItemVO in items){
					if(!itemVO.isComplete) return false ;
				}
			}
			return false ;
		}
	}
}