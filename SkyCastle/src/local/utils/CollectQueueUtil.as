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
		private var _queue:Array= [];
		
		//当前正在处理的建筑
		public var currentBuilding:Building=null ;
		
		/**
		 * 添加建筑到队列中 
		 * @param building
		 */		
		public function addBuilding( building:Building ):void
		{
			_queue.push( building );
			if(currentBuilding==null ){
				nextBuilding();
			}
		}
		
		/**
		 * 继续下一个建筑
		 */		
		public function nextBuilding():void
		{
			if(_queue.length>0){
				currentBuilding = _queue.shift() as Building;
				currentBuilding.characterMoveTo( CharacterManager.instance.hero ); //英雄走到建筑旁边
			}else{
				currentBuilding = null ;
			}
		}
		
		/** 清除队列 */
		public function clear():void
		{
			_queue = [] ;
			currentBuilding = null ;
		}
	}
}