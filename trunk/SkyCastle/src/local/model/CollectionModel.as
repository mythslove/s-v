package local.model
{
	import local.model.vos.CollectionVO;
	import local.model.vos.ConfigBaseVO;
	import local.model.vos.PickupVO;

	/**
	 * 所有的收集物Model 
	 * @author zzhanglin
	 */	
	public class CollectionModel
	{
		private static var _instance:CollectionModel;
		public static function get instance():CollectionModel
		{
			if(!_instance) _instance = new CollectionModel();
			return _instance; 
		}
		//=================================
		/** 所有的收集物配置 */
		public var allCollections:Vector.<CollectionVO> ;
		
		/**
		 * 解析加载的配置文件 
		 * @param config
		 */		
		public function parseConfig( config:ConfigBaseVO ):void
		{
			allCollections = Vector.<CollectionVO>(config.collections) ;
		}
	}
}