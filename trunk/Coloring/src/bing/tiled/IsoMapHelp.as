package bing.tiled
{
	import flash.geom.Point;

	public class IsoMapHelp
	{
		
		//直角坐标转斜45度 
		public static function xy45(tileWidth:int , tileHeight:int , px:int , py:int ) :Point
		{
			var p:Point = new  Point();
			p.x=int(0.5*((px<<1)+px)/(tileWidth>>1));
			p.y=int(0.5*((py<<1)-py)/(tileHeight>>1));

			return p;
		} 
		
		/**
		 * 根据屏幕象素坐标取得网格的坐标 
		 * @param px
		 * @param py
		 * @return 
		 * 
		 */		
		public static function getCellPoint( tileWidth:int , tileHeight:int , px:int , py:int):Point
		{
			var xtile:int = 0;	
			var ytile:int = 0;	
			
			var cx:int, cy:int, rx:int, ry:int;
			cx = int(px / tileWidth) * tileWidth + tileWidth*0.5;	
			cy = int(py / tileHeight) * tileHeight + tileHeight*0.5;
			
			rx = (px - cx) * tileHeight*0.5;
			ry = (py - cy) * tileWidth*0.5;
			
			if (Math.abs(rx)+Math.abs(ry) <= tileWidth * tileHeight*0.25)
			{
				//xtile = int(pixelPoint.x / tileWidth) * 2;
				xtile = int(px / tileWidth);
				ytile = int(py / tileHeight) * 2;
			}
			else
			{
				px = px - tileWidth*0.5;
				//xtile = int(pixelPoint.x / tileWidth) * 2 + 1;
				xtile = int(px / tileWidth) + 1;
				
				py = py - tileHeight*0.5;
				ytile = int(py / tileHeight) * 2 + 1;
			}
			
			return new Point(xtile - (ytile&1), ytile);
		}
		
		/**
		 * 根据网格坐标取得象素坐标 
		 * @param tileWidth
		 * @param tileHeight
		 * @param tx
		 * @param ty
		 * @return 
		 */		
		public static function getPixelPoint( tileWidth:int , tileHeight:int ,  tx:int, ty:int):Point
		{
			//偶数行tile中心
			var tileCenter:int = (tx * tileWidth) + tileWidth*0.5;
			// x象素  如果为奇数行加半个宽
			var xPixel:int = tileCenter + (ty&1) * tileWidth*0.5;
			// y象素
			var yPixel:int = (ty + 1) * tileHeight*0.5;
			return new Point(xPixel, yPixel);
		}
	}
}