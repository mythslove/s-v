package models
{
	import bing.iso.path.Grid;
	
	import comm.GameSetting;
	
	import flash.utils.Dictionary;

	/**
	 * 寻路用的 
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
		public var roadGrid:Grid = new Grid(GameSetting.GRID_X , GameSetting.GRID_Z);
		
		
		/**
		 * 额外的地图数据 
		 */		
		public var extraHash:Dictionary ; 
	}
}