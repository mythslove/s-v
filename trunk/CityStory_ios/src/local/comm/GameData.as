package  local.comm
{
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class GameData
	{
		/**
		 * 公用的date
		 */		
		public static var commDate:Date = new Date();
		
		/**
		 * 公用 的point 
		 */		
		public static var commPoint:Point = new Point();
		
		/**
		 * 公用 的Vector3D 
		 */	
		public static var commVec:Vector3D = new Vector3D();
		
		/**
		 *  是否为地图编辑状态
		 */		
		public static var villageEditor:Boolean = true ;
	}
}