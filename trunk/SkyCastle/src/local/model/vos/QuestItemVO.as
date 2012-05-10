package local.model.vos
{
	public class QuestItemVO
	{
		public var itemId:int ;
		public var current:int ;
		public var sum:int ;
		public var title:String ;
		public var skipCash:int ;
		public var isSkipped:Boolean ;
		public var icon:String ;
		
		public var questType:String ;
		public var sonType:String ;
		
		/**
		 * 这个item是否完成 
		 * @return 
		 */		
		public function get isComplete():Boolean
		{
			if(isSkipped || current>=sum ) return true;
			return false ;
		}
	}
}