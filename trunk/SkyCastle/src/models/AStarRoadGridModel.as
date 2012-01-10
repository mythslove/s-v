package models
{
	import bing.iso.path.Grid;
	
	import comm.GameSetting;
	
	import flash.utils.Dictionary;

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
		/**
		 * 用于寻路的数据 
		 */		
		public var roadGrid:Grid = new Grid(GameSetting.GRID_X , GameSetting.GRID_Z);
		
		
		/**
		 * 额外的地图数据 
		 */		
		public var extraHash:Dictionary ; 
	}
}