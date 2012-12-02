package game.model
{
	import bing.res.ResVO;
	
	import game.vos.CarVO;
	
	import nape.geom.Vec2;

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
			cars = new Vector.<CarVO>();
			
		}
	}
}