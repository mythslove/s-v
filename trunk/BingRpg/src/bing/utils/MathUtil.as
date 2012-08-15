package bing.utils
{
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
		
		
	}
}