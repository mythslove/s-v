package game.model
{
	import bing.res.ResVO;
	
	import game.vos.AIVO;

	public class AIModel
	{
		private static var _instance:AIModel;
		public static function get instance():AIModel{
			if(!_instance) _instance = new AIModel();
			return _instance ;
		}
		//===============================
		
		public var aiCars:Vector.<AIVO>;
		
		public function parseConfig( resVO:ResVO ):void
		{
			var config:XML = XML (resVO.resObject ) ;
			aiCars = new Vector.<AIVO>();
			
		}
	}
}