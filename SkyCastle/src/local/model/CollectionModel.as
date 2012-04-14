package local.model
{
	import bing.amf3.ResultEvent;
	import bing.utils.SystemUtil;
	
	import local.comm.GameRemote;
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
		
		private var _ro:GameRemote ;
		public function PickupModel()
		{
			_ro = new GameRemote("CommService");
			_ro.addEventListener(ResultEvent.RESULT ,  onResultHandler );
		}
		
		private function onResultHandler( e:ResultEvent ):void
		{
			SystemUtil.debug("返回数据：",e.service+"."+e.method , e.result );
			switch( e.method )
			{
			}
		}
		
		/**
		 * 解析加载的配置文件 
		 * @param config
		 */		
		public function parseConfig( config:ConfigBaseVO ):void
		{
			allCollections = Vector.<CollectionVO>(config.collections) ;
		}
		
		/**
		 * 通过 pickupId来获取CollectionVO 
		 * @param pickupId
		 * @return 
		 */		
		public function getCollectionByPickupId( pickupId:String ):CollectionVO
		{
			if(allCollections){
				for each( var vo:CollectionVO in allCollections)
				{
					if(vo.pickups)
					{
						for each( var pvo:PickupVO in vo.pickups)
						{
							if(pickupId == pvo.pickupId ) return vo ;
						}
					}
				}
			}
			return null ;
		}
	}
}