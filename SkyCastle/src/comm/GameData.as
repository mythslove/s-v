package comm
{
	import flash.geom.Point;
	
	import map.elements.BuildingBase;

	public class GameData
	{
		/**
		 *  当前对建筑的操作
		 */		
		public static var buildingCurrOperation:String = "add";
		
		/**
		 * 鼠标在哪个上面 
		 */		
		public static var mouseBuilding:BuildingBase ; 
		
		/**
		 * 坐标0点 
		 */		
		public static const zeroPoint:Point = new Point();
	}
}