package game.model
{
	import bing.res.ResVO;
	
	import flash.utils.Dictionary;
	
	import game.vos.CarParamVO;
	import game.vos.CarVO;

	public class CarModel
	{
		private static var _instance:CarModel;
		public static function get instance():CarModel{
			if(!_instance) _instance = new CarModel();
			return _instance ;
		}
		//===============================
		public var cars:Vector.<CarVO> ;
		
		public function CarModel()
		{
			
		}
		
		public function parseConfig( resVO:ResVO ):void
		{
			var config:XML = XML(resVO.resObject);
			cars = new Vector.<CarVO>();
			for each( var item:* in config.children())
			{
				var carVO:CarVO = new CarVO();
				cars.push( carVO );
				carVO.id = int( item.@id );
				carVO.name = String( item.@name );
				carVO.costCoin = int( item.@costCoin );
				carVO.costCash = int( item.@costCash );
				carVO.requireLevel = int( item.@requireLevel );
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
			}
		}
	}
}