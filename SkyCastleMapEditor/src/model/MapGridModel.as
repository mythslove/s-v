package model
{
	public class MapGridModel
	{
		private static var _instance:MapGridModel ;
		public static function get instance():MapGridModel{
			if(!_instance) _instance = new MapGridModel();
			return _instance ;
		}
		//=================================
	}
}