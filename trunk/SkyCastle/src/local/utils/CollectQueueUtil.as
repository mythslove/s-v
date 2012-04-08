package local.utils
{
	import local.enum.AvatarAction;
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
			}else if(currentBuilding){
				CharacterManager.instance.hero.gotoAndPlay(AvatarAction.IDLE);
				currentBuilding.enable = true ;
				currentBuilding = null ;
			}
		}
		
		/**
		 * 判断建筑是否在队列中 
		 * @param build
		 * @return 
		 */		
		public function checkInQueue( build:Building ):Boolean
		{
			for each( var building:Building in _queue){
				if(build==building) return true ;
			}
			return false ;
		}
		
		/** 清除队列 */
		public function clear( deep:Boolean = false ):void
		{
			for each( var building:Building in _queue){
				building.enable=true ;
			}
			if(deep){
				if(currentBuilding){
					currentBuilding.enable=true ;
				}
				currentBuilding = null ;
			}
			_queue = [] ;
		}
	}
}