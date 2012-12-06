package game.model
{
	import bing.res.ResVO;
	import bing.utils.ObjectUtil;
	
	import flash.utils.Dictionary;
	
	import game.vos.CarParamVO;
	import game.vos.CarVO;
	import game.vos.PlayerCarVO;

	public class CarModel
	{
		private static var _instance:CarModel;
		public static function get instance():CarModel{
			if(!_instance) _instance = new CarModel();
			return _instance ;
		}
		//===============================
		/**
		 * 玩家拥有的车 
		 */		
		public var playerCars:Vector.<PlayerCarVO> = new Vector.<PlayerCarVO>();
		
		/**
		 * 商店中的车 
		 */		
		public var cars:Vector.<CarVO> = new Vector.<CarVO>();
		
		/**
		 * 商店中的车,key为车的id , value为CarVO 
		 */		
		public var carsHash:Dictionary = new Dictionary();
		
		/**
		 * 解析商店中的车的配置 
		 * @param resVO
		 */		
		public function parseConfig( resVO:ResVO ):void
		{
			var config:XML = XML(resVO.resObject);
			for each( var item:* in config.children())
			{
				var carVO:CarVO = new CarVO();
				cars.push( carVO );
				carVO.id = int( item.@id );
				carVO.name = String( item.@name );
				carVO.costCoin = int( item.@costCoin );
				carVO.costCash = int( item.@costCash );
				carVO.requireLevel = int( item.@requireLevel );
				carVO.drive = int( item.@drive );
				carVO.carParams = new Dictionary();
				for each( var child:* in item.children())
				{
					var paramVO:CarParamVO = new CarParamVO();
					paramVO.name = child.name() ;
					paramVO.levels = int( child.@levels);
					paramVO.value = Number( child.@value);
					paramVO.add = Number( child.@add);
					carVO.carParams[paramVO.name] = paramVO ;
				}
				carsHash[carVO.id]=carVO;
			}
		}
		
		/**
		 * 初始化一个默认的PlayerCarVO
		 */		
		public function initDefaultPlayerCarVO():PlayerCarVO
		{
			var vo:PlayerCarVO = new PlayerCarVO();
			vo.carVO = ObjectUtil.copyObj( cars[1] ) as CarVO ;
			playerCars.push(vo);
			return vo ;
		}
	}
}