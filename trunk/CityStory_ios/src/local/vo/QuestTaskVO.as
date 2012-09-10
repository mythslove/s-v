package local.vo
{
	import local.enum.QuestType;
	import local.model.QuestModel;

	public class QuestTaskVO
	{
		public var questId:String ; 
		public var current:int ; //当前多少个
		public var sum:int=1 ; //总共需要多少个
		public var title:String ; //标题
		public var skipCash:int ; //跳过这个任务需要的钱，如果为0，则不判断这个
		public var isSkipped:Boolean ; //是否跳过
		
		public var questType:String ; //任务的类型
		public var sonType:String ; //子类型
		
		/**
		 * 这个item是否完成 
		 * @return 
		 */		
		public function get isComplete():Boolean
		{
			if( (skipCash>0 && isSkipped) || current>=sum ) return true;
			return false ;
		}
		
		
		/**
		 * 初始化数据
		 */		
		public function init( acceptTime:int ):void
		{
			if ( current>0 ) return ;
			
			switch( questType)
			{
				case QuestType.OWN_BUILDING:
					if(sonType){
						current = QuestModel.instance.getCountByName( sonType );
					}
					break ;
			}
		}
	}
}