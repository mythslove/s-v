package local.model
{
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
		
		/** 玩家已经收集到的所有的pickup, key为pickupId , value为数量 */
		public var playerPickups:Object ;
		
		/**
		 * 解析加载的配置文件 
		 * @param config
		 */		
		public function parseConfig( config:ConfigBaseVO ):void
		{
			pickups = config.pickups ;
		}
		
		/**
		 * 通过pickupId获得pickupVO 
		 * @param pickupId
		 * @return 
		 */		
		public function getPickupById( pickupId:String ):PickupVO
		{
			var vo:PickupVO ;
			if(pickups && pickups.hasOwnProperty(vo.pickupId)){
				vo =  pickups[pickupId] as PickupVO;
			}
			return vo ;
		}
		
		/**
		 * 添加一个pickup 
		 * @param pickup 
		 * @param num
		 */		
		public function addPickup( pickupId:String , num:int = 1 ):void
		{
			if(playerPickups){
				if( playerPickups.hasOwnProperty(pickupId ) ){
					playerPickups[pickupId] += num ;
				}else{
					playerPickups[pickupId] = num ;
				}
			}else{
				playerPickups = new Object();
				playerPickups[pickupId] = num ;
			}
		}
		
		/**
		 * 删除pickupVO 
		 * @param pickup 
		 * @param num 要删除的数量
		 */		
		public function deletePickup( pickupId:String , num:int=1 ):void
		{
			if( playerPickups && playerPickups.hasOwnProperty(pickupId) ){
				playerPickups[pickupId] -= num ;
				if( playerPickups[pickupId]<=0){
					delete playerPickups[pickupId] ;
				}
			}
		}
	}
}