package bing.iso
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class IsoUtils
	{
		// a more accurate version of 1.2247...
		public static const Y_CORRECT:Number = Math.cos(-Math.PI / 6) * Math.SQRT2;
		
		/**
		 * Converts a 3D point in isometric space to a 2D screen position.
		 * @arg pos the 3D point.
		 */
		public static function isoToScreen(pos:Vector3D):Point
		{
			var screenX:Number = pos.x - pos.z;
			var screenY:Number = pos.y * Y_CORRECT + (pos.x + pos.z) * .5;
			return new Point(screenX, screenY);
		}
		
		/**
		 * Converts a 2D screen position to a 3D point in isometric space, assuming y = 0.
		 * @arg point the 2D point.
		 */
		public static function screenToIso(point:Point):Vector3D
		{
			var xpos:Number = point.y + point.x * .5;
			var ypos:Number = 0;
			var zpos:Number = point.y - point.x * .5;
			return new Vector3D(xpos, ypos, zpos);
		}
		
		/**
		 * flash坐标系转 正确的iso坐标
		 * @param size 格子大小
		 * @param px 
		 * @param py
		 * @return 
		 */		
		public static function screenToIsoGrid( size:int , px:Number , py:Number ) :Point
		{
			var xpos:Number = py + px * .5;
			var zpos:Number = py - px * .5;
			
			var col:Number = Math.floor(xpos / size );
			var row:Number = Math.floor( zpos / size);
			return new Point(col,row) ;
		} 
	}
}