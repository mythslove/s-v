package local.model.vos
{
	public class QuestVO
	{
		public var qid:int ;
		public var title:String ;
		public var info:String ;
		public var icon:String ;
		public var completeMsg:String ;
		
		public var isAccept:Boolean;
		public var isComplete:Boolean;
		public var isReceive:Boolean ;
		public var acceptTime:Number ;
		public var items:Array ;
		public var rewardsVO:RewardsVO;
	}
}