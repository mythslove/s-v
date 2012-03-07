package local.utils
{
	import local.game.elements.Building;

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
		
		//队列数组
		public var queue:Array= [];
		
		//当前正在处理的建筑
		public var currentBuilding:Building ;
		
		public function addBuilding( building:Building ):void
		{
			queue.push( building );
		}
		
		/** 清除队列 */
		public function clear():void
		{
			queue = [] ;
			currentBuilding = null ;
		}
	}
}