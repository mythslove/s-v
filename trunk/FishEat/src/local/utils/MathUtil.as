package  local.utils
{
	import flash.geom.Point;

	public class MathUtil
	{
		/**
		 * 两点之间的距离，速度比Point.distance快 
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return 
		 */		
		public static function distance(x1:Number , y1:Number , x2:Number, y2:Number):Number
		{
			var m:Number = 0;
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			m = Math.sqrt(dx * dx + dy * dy);
			return m;
		}
		
		/**
		 * 获得 随机的-1和1
		 * @return 
		 */		
		public static function getRandomFlag():int{
			if (Math.random()>=0.5)
			{
				return 1;
			}
			return -1;
		}
		
		/**
		 * 点到线的交点 ，即垂足坐标
		 * @param pt1  直线上的点
		 * @param pt2  直线上的点
		 * @param pt3
		 * @return 
		 */		
		public  static function  point2linePedal(pt1:Point , pt2:Point , pt3:Point):Point
		{
			var x:Number = 0 ;
			var k:Number = ( pt2.y - pt1. y ) / (pt2.x - pt1.x ); //斜率
			var y:Number = (-1/k) * (x - pt3.x) + pt3.y  ;//垂线的直线方程
			x  =  ( k*k * pt1.x + k * (pt3.y - pt1.y ) + pt3.x ) / ( k*k + 1)  ;
			y  =  k * ( x - pt1.x) + pt1.y; 
			var p:Point = new Point( x,y);
			return p;  
		}
		
		/**
		 * point到line的距离
		 * @param pt1 直线上的点
		 * @param pt2 直线上的点
		 * @param pt3 
		 * @return 
		 */		
		public static function point2LineDistance( pt1:Point , pt2:Point , pt3:Point ):Number
		{
			var A:Number = (pt1.y-pt2.y)/(pt1.x- pt2.x);  
			var B:Number = (pt1.y-A*pt1.y);  
			return Math.abs(A*pt3.x + B -pt3.y)/Math.sqrt(A*A + 1);  
		}
	}
}