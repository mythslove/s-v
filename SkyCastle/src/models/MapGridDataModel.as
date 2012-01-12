package models
{
	import bing.iso.path.Grid;
	
	import comm.GameSetting;
	
	import flash.utils.Dictionary;

	/**
	 * 地图的网格数据
	 * @author zhouzhanglin
	 */	
	public class MapGridDataModel
	{
		private static var _instance:MapGridDataModel ;
		public static function get instance():MapGridDataModel
		{
			if(!_instance) _instance = new MapGridDataModel();
			return _instance;
		}
		//=======================================
		/**
		 * 用于寻路的数据 
		 */		
		public var astarGrid:Grid = new Grid(GameSetting.GRID_X , GameSetting.GRID_Z);
		
		/**
		 * 额外的地图数据 
		 */		
		public var extraHash:Dictionary ; 
		
		/**
		 * 建筑层数据 
		 */		
		public var buildingGrid:Grid  = new Grid(GameSetting.GRID_X , GameSetting.GRID_Z);
		
		/**
		 * 地面层数据 
		 */		
		public var groundGrid:Grid = new Grid(GameSetting.GRID_X , GameSetting.GRID_Z);
	}
}