package local.utils
{
	/**
	 * 建筑队列处理类 
	 * @author zhouzhanglin
	 */	
	public class CollectQueueUtil
	{
		private static var _instance:CollectQueueUtil ;
		public static function get instance():CollectQueueUtil
		{
			if(!_instance) _instance = new CollectQueueUtil();
			return _instance ;
		}
		//=================================
		
	}
}