package local.model
{
	import bing.amf3.ResultEvent;
	import bing.utils.SystemUtil;
	
	import local.comm.GameRemote;
	import local.model.vos.ConfigBaseVO;
	import local.model.vos.PickupVO;

	/**
	 * 所有的pickup管理 
	 * @author zzhanglin
	 */
	public class PickupModel
	{
		private static var _instance:PickupModel;
		public static function get instance():PickupModel
		{
			if(!_instance) _instance = new PickupModel();
			return _instance; 
		}
		//=================================
		/** 所有的pickup配置，key为pickupId , value为PickupVO*/
		public var pickups:Object ;
		
		/** 玩家已经收集到的所有的pickup */
		public var playerPickups:Vector.<PickupVO> ;
		
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
				case "getPickup":
					playerPickups = Vector.<PickupVO>( e.result );
					break ;
			}
		}
		
		
		/**
		 * 解析加载的配置文件 
		 * @param config
		 */		
		public function parseConfig( config:ConfigBaseVO ):void
		{
			pickups = config.pickups ;
		}
		
		/**
		 * 通过alias获得pickupVO 
		 * @param alias
		 * @return 
		 */		
		public function getPickupByAlias( alias:String ):PickupVO
		{
			var vo:PickupVO ;
			if(pickups && pickups.hasOwnProperty(vo.alias)){
				vo =  pickups[alias] as PickupVO;
			}
			return vo ;
		}
		
		/**
		 * 根据类型返回玩家收集的所有PickVO 
		 * @return 
		 */		
		public function getPlayerPickupsByType( type:String ):Vector.<PickupVO>
		{
			var arr:Vector.<PickupVO> = new Vector.<PickupVO>();
			if(playerPickups)
			{
				for each( var vo:PickupVO in playerPickups){
					if(vo.type==type)
					{
						playerPickups.push( vo);
					}
				}
			}
			return arr ;
		}
		
		/**
		 * 添加一个pickup 
		 * @param pickup 
		 * @param num
		 */		
		public function addPickup( pickup:PickupVO , num:int = 1 ):void
		{
			if(playerPickups){
				var len:int = playerPickups.length ;
				for( var i:int = 0 ; i<len ; ++i){
					if( playerPickups[i] == pickup) {
						pickup.num+=num;
						return ;
					}
				}
				pickup.num=1 ;
				playerPickups.push( pickup );
			}
		}
		
		/**
		 * 删除pickupVO 
		 * @param pickup 
		 * @param num 要删除的数量
		 */		
		public function deletePickup( pickup:PickupVO , num:int=1 ):void
		{
			pickup.num--;
			if(playerPickups && pickup.num<=0){
				var len:int = playerPickups.length ;
				for( var i:int = 0 ; i<len ; ++i){
					if( playerPickups[i] == pickup) {
						playerPickups.slice(i,1);
						break ;
					}
				}
			}
		}
		
		/**
		 * 获取用户收集的pickups 
		 */		
		public function getPlayerPickups():void
		{
			_ro.getOperation("getPickup").send();
		}
	}
}