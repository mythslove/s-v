package game.model
{
	import bing.res.ResVO;

	public class TrackModel
	{
		private static var _instance:TrackModel;
		public static function get instance():TrackModel{
			if(!_instance) _instance = new TrackModel();
			return _instance ;
		}
		//===============================
		
		public function TrackModel()
		{
			
		}
		
		public function parseConfig( resVO:ResVO ):void
		{
			
		}
	}
}