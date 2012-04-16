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
		/** 所有的收集物配置 , key为groupid , CollectionVO*/
		public var collectionsHash:Object ;
		
		/** groupId数组，用于界面的遍历显示 */
		public var collectionArray:Vector.<CollectionVO> ;
		
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
			collectionArray = new Vector.<CollectionVO>();
			var cvo:CollectionVO;
			var pvo:PickupVO ;
			var len:int ;
			for( var key:String in collectionsHash){
				cvo = collectionsHash[key] ;
				collectionArray.push( cvo );
				len = cvo.pickups.length ;
				for( var i:int = 0 ; i<len ;++i)
				{
					pvo = config.pickups[cvo.pickups[i]] ;
					pvo.groupId = cvo.groupId;
				}
			}
		}
		/**
		 * groupId的当前等级 
		 * @param groupId
		 * @return 
		 */		
		public function getCollLvByGrounp( groupId:String):int
		{
			if( myCollection && myCollection.hasOwnProperty(groupId)){
				return myCollection[groupId] ;
			}
			return 0 ;
		}
		
		/**
		 * 通过groupId返回CollectionVO 
		 * @param groupId
		 * @return 
		 */		
		public function getCollectionById( groupId:String ):CollectionVO
		{
			return collectionsHash[groupId] as CollectionVO;;
		}
	}
}