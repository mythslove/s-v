package local.model
{
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
	}
}