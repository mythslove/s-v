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
		public var myPickups:Object ;
		
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
		
		
		
		
		
		//==================玩家的pickup方法======================
		
		
		/**
		 * 获取玩家收集的pickup数量 
		 * @param pickupId
		 * @return 
		 */		
		public function getMyPickupCount( pickupId:String):int
		{
			if(myPickups && myPickups.hasOwnProperty(pickupId)){
				return myPickups[pickupId] ;
			}else{
				myPickups[pickupId] =1 ;
				return 1 ;
			}
			return 0 ;
		}
		
		/**
		 * 添加一个pickup 
		 * @param pickup 
		 * @param num
		 */		
		public function addPickup( pickupId:String , num:int = 1 ):void
		{
			if(myPickups){
				if( myPickups.hasOwnProperty(pickupId ) ){
					myPickups[pickupId] += num ;
				}else{
					myPickups[pickupId] = num ;
				}
			}else{
				myPickups = new Object();
				myPickups[pickupId] = num ;
			}
		}
		
		/**
		 * 删除pickupVO 
		 * @param pickup 
		 * @param num 要删除的数量
		 */		
		public function deletePickup( pickupId:String , num:int=1 ):void
		{
			if( myPickups && myPickups.hasOwnProperty(pickupId) ){
				myPickups[pickupId] -= num ;
				if( myPickups[pickupId]<=0){
					delete myPickups[pickupId] ;
				}
			}
		}
	}
}