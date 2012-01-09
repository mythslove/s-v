package comm
{
	import flash.geom.Point;
	

	public class GameData
	{
		/**
		 *  当前对建筑的操作
		 */		
		public static var buildingCurrOperation:String = "none";
		
		/**
		 * 当前在添加哪个地图的数据 
		 */		
		public static var currentMap:int = 1 ;
		/**
		 * 当前的地图数据的颜色 
		 */		
		public static var currentMapColor:uint = GameSetting.Map1Color ;
		
		/**
		 * 坐标0点 
		 */		
		public static const zeroPoint:Point = new Point();
	}
}