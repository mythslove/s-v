package local.comm
{
	public class GameSetting
	{
		
		//屏幕大小 
		public static var SCREEN_WIDTH:int =960;
		public static var SCREEN_HEIGHT:int = 640;
		
		
		//地图大小
		public static var MAP_WIDTH:int = 4000;
		public static var MAP_HEIGHT:int = 2800;
		
		/** 网格大小 */		
		public static var GRID_SIZE:int = 60 ;
		
		/** 地图大小*/
		public static var GRID_X:int = 30 ;
		public static var GRID_Z:int = 30 ;
		
		/** 地图的最大缩放值 */
		public static var minZoom:Number=0.7 ;
		
		public static var isIpad:Boolean ;
		
		public static function get GAMESCALE():Number{
			return isIpad? 1 : 0.5 ;
		}
	}
}