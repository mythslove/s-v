package local.model
{
	import local.vo.LandVO;

	public class LandModel
	{
		private static var _instance:LandModel ;
		public static function get instance():LandModel
		{
			if(!_instance) _instance = new LandModel();
			return _instance;
		}
		//=======================================
		
		public var lands:Vector.<LandVO> ;
	}
}