package bing.utils
{
	import flash.geom.Point;
	/**
	 *贝塞尔曲线 
	 * @author zhouzhanglin
	 * 
	 */	
	public class BezierCurve
	{
		
		/**
		 *@ t (0-1之间)
		 *@points 基本的点
		 */
		static public function getPoint(t:Number, points:Vector.<Point>):Point
		{
			//clear totals
			var x:Number = 0;
			var y:Number = 0;
			//calculate n
			var n:uint = points.length-1;
			//calculate n!
			var factn:Number = factoral(n);
			//loop thru points
			for (var i:uint=0;i<=n;i++)
			{
				//calc binominal coefficent
				var b:Number = factn/(factoral(i)*factoral(n-i));
				//calc powers
				var k:Number = Math.pow(1-t, n-i)*Math.pow(t, i);
				//add weighted points to totals
				x += b*k*points[i].x;
				y += b*k*points[i].y;
			}
			//return result
			return new Point(x, y);
		}
		
		static private function factoral(value:uint):Number
		{
			//return special case
			if (value==0)
				return 1;
			//calc factoral of value
			var total:Number = value;
			while (--value>1)
				total *= value;
			//return result
			return total;
		}
	}
}