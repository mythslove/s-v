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
		public var pickups:Object ;
		
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
		
	}
}