package model
{
	import bing.iso.path.Grid;
	
	import comm.GameSetting;

	public class MapGridModel
	{
		private static var _instance:MapGridModel ;
		public static function get instance():MapGridModel{
			if(!_instance) _instance = new MapGridModel();
			return _instance ;
		}
		//=================================
		public var grid:Grid = new Grid(GameSetting.GRID_X , GameSetting.GRID_Z );
	}
}