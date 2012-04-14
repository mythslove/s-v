package local.model
{
	import bing.amf3.ResultEvent;
	import bing.utils.SystemUtil;
	
	import local.comm.GameRemote;
	import local.model.vos.CollectionVO;
	import local.model.vos.ConfigBaseVO;

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
		/** 所有的收集物配置 , key为groupid , value为[CollectionVO]*/
		public var collectionsHash:Object ;
		
		/** groupId数组，用于界面的遍历显示 */
		public var collectionArray:Vector.<String> ;
		
		/** 我已经 收集的 , key为groupId , value为兑换等级*/
		public var myCollection:Object ;
		
		private var _ro:GameRemote ;
		public function CollectionModel()
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
			collectionsHash = config.collections ;
			collectionArray = new Vector.<String>();
			for( var key:String in collectionsHash){
				collectionArray.push( key );
			}
		}
		
		/**
		 * 通过groupId获取所有的CollectionVO 
		 * @param groupId
		 * @return 
		 */		
		public function getCollectionsByGroundId( groupId:String ):Array
		{
			return collectionsHash[groupId] as Array ;
		}
		
		
		/**
		 * 通过groupid 和 兑换等级来获得CollectionVO 
		 * @param groupId Collection组id
		 * @param lv 兑换等级
		 * @return  
		 */		
		public function getCollectionByLvAndId( groupId:String , lv:int ):CollectionVO
		{
			return getCollectionsByGroundId(groupId)[lv] as CollectionVO ;
		}
	}
}