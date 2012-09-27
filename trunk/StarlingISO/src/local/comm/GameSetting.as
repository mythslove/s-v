package local.comm
{
	public class GameSetting
	{
		//屏幕大小 
		public static var SCREEN_WIDTH:int =960;
		public static var SCREEN_HEIGHT:int = 640;
		
		
		//地图大小
		public static const MAP_WIDTH:int = 4000;
		public static const MAP_HEIGHT:int = 2800;
		
		/** 网格大小 */		
		public static const GRID_SIZE:int = 60 ;
		
		/** 地图大小*/
		public static var GRID_X:int = 30 ;
		public static var GRID_Z:int = 30 ;
		
		/** 地图的最大缩放值 */
		public static var minZoom:Number=0.7 ;
		
		/** 本地语言 */
		public static var local:String = "en";
		
		public static var device:String =  "iphone";
		
		/*facebookId*/
		public static var fdId:String = "village";
	}
}