package game.model
{
	import bing.res.ResVO;

	public class AIModel
	{
		private static var _instance:AIModel;
		public static function get instance():AIModel{
			if(!_instance) _instance = new AIModel();
			return _instance ;
		}
		//===============================
		
		public function AIModel()
		{
			
		}
		
		public function parseConfig( resVO:ResVO ):void
		{
			
		}
	}
}