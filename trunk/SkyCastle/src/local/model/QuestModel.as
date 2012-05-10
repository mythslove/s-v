package local.model
{
	import local.model.vos.QuestVO;

	/**
	 * 任务数据 
	 * @author zhouzhanglin
	 * 
	 */	
	public class QuestModel
	{
		private static var _instance:QuestModel;
		public static function get instance():QuestModel
		{
			if(!_instance) _instance = new QuestModel();
			return _instance; 
		}
		//=================================
		
		public var currentQuests:Vector.<QuestVO> ;
		
		public function getQuestById( qid:int ):QuestVO
		{
			if(currentQuests){
				var len:int = currentQuests.length ;
				for( var i:int =0 ; i<len ; ++i){
					if(currentQuests[i].qid==qid) {
						return currentQuests[i] ;
					}
				}
			}
			return null ;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		//=====================计算和统计quest中的数据===========================
		
		
	}
}