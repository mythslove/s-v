package comm
{
	/**
	 * 游戏的设置 
	 * @author zzhanglin
	 */	
	public class GameSetting
	{
		//屏幕固定大小 
		public static const SCREEN_WIDTH:int =760;
		public static const SCREEN_HEIGHT:int = 620;
		
		
		//地图区域的大小
		public static const MAP_WIDTH:int = 2072;
		public static const MAP_HEIGHT:int = 2072;
		
		//地图最大大小
		public static var MAX_WIDTH:int = 0 ;
		public static var MAX_HEIGHT:int = 0 ;
		
		//网格大小
		public static const GRID_SIZE:int = 50 ;
		
		//网格的数量
		public static const GRID_X:int = 74;
		public static const GRID_Z:int = 74 ;
		
		
		public static const Map1Color:uint = 0xff0000;
		public static const Map2Color:uint = 0xff5b5b;
		public static const Map3Color:uint = 0xffc4c4 ;
		public static const RoadColor:uint = 0xffcc00 ;
	}
}