package local.model
{
	import bing.amf3.ResultEvent;
	import bing.utils.SystemUtil;
	
	import local.comm.GameRemote;
	import local.model.vos.CollectionVO;
	import local.model.vos.ConfigBaseVO;
	import local.model.vos.PickupVO;
	import local.model.vos.RewardsVO;
	import local.utils.PickupUtil;

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
		 * 通过groupId返回CollectionVO 
		 * @param groupId
		 * @return 
		 */		
		public function getCollectionById( groupId:String ):CollectionVO
		{
			return collectionsHash[groupId] as CollectionVO;;
		}
		
		
		
		//===========我收集的===================
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
		 *  添加一组collection或者升级一组collection
		 * @param groupId
		 * @param num
		 */		
		private function addCollection( groupId:String  , num:int= 1 ):void
		{
			if(myCollection.hasOwnProperty(groupId)){
				myCollection[groupId]+=num;
			}else{
				myCollection[groupId]=1;
			}
		}
		
		//==============================================
		
		private function onResultHandler( e:ResultEvent ):void
		{
			SystemUtil.debug("返回数据：",e.service+"."+e.method , e.result );
			switch( e.method )
			{
				case "turnIn":
					if(e.result)
					{
						var groupId:String  = e.result.groupId ;
						var lv:int = e.result.level ;
						var cvo:CollectionVO = this.getCollectionById(groupId);
						var exchangeRewards:RewardsVO = cvo.exchanges[lv] ;
						PickupUtil.addRewards2World(exchangeRewards);
						var extraRewards:RewardsVO = cvo.extras[lv] ;
						if(extraRewards){
							//弹出Collection奖励窗口
						}
					}
					break ;
			}
		}
		
		/**
		 *  发送turnin的消息到服务器  
		 * @param groupId
		 * @param lv
		 */		
		public function sendTurnIn( groupId:String , lv:int ):void
		{
			_ro.getOperation("turnIn").send(groupId , lv );
		}
			
	}
}