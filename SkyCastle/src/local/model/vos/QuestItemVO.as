package local.model.vos
{
	public class QuestItemVO
	{
		public var itemId:int ; //id
		public var current:int ; //当前多少个
		public var sum:int=1 ; //总共需要多少个
		public var title:String ; //标题
		public var skipCash:int ; //跳过这个任务需要的钱
		public var isSkipped:Boolean ; //是否跳过
		public var icon:String ; //icon名称
		
		public var questType:String ; //任务的类型
		public var sonType:String ; //了类型
		
		/**
		 * 这个item是否完成 
		 * @return 
		 */		
		public function get isComplete():Boolean
		{
			if( (skipCash>0 && isSkipped) || current>=sum ) return true;
			return false ;
		}
	}
}