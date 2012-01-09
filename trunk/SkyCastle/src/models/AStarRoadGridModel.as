package models
{
	import bing.iso.path.Grid;
	
	import comm.GameSetting;

	/**
	 * 寻路用的 
	 * @author zhouzhanglin
	 */	
	public class AStarRoadGridModel
	{
		private static var _instance:AStarRoadGridModel ;
		public static function get instance():AStarRoadGridModel
		{
			if(!_instance) _instance = new AStarRoadGridModel();
			return _instance;
		}
		//=======================================
		public var roadGrid:Grid = new Grid(GameSetting.GRID_X , GameSetting.GRID_Z);
	}
}