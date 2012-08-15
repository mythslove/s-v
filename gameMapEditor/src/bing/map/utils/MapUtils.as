package bing.map.utils
{
	import bing.map.data.Comm;
	import bing.map.data.MapData;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;

	/**
	 * 地图工具类 
	 * @author zhouzhanglin
	 */	
	public class MapUtils
	{
		//地图容器的滚动条距离
		public static var mapXScroll:int = 0;
		public static var mapYScroll:int = 0;
		
		
		/**
		 * 获得当前屏幕上的单元格坐标(0,1)点集合 
		 * @return 当前能看见的屏幕的单元格坐标数组
		 */		
		public static function getScreenPointArr():Array{
			var arr:Array  = new Array();
			//获得当前可见屏幕的网格最大坐标和最小坐标
			var min:Point = getCellPoint(mapXScroll, mapYScroll);
			var max:Point = getCellPoint(Comm.mainApp.mapContainer.width + mapXScroll , Comm.mainApp.mapContainer.height+mapYScroll);
			//如果当前坐标没有屏幕那么大
			if(max.y>=MapData.yNum){
				max.y=MapData.yNum;
			}else{
				max.y +=1;
			}
			if(max.x>=MapData.xNum){
				max.x=MapData.xNum;
			}else{
				max.x+=1;
			}
			//循环当前可见屏幕的坐标
			for(var i:uint = min.x; i< max.x+1 ; i++){
				for(var j:uint = min.y-1 ; j<max.y*2-1 ;j++){
					if(i<MapData.xNum){
						arr.push( i+"_"+j );
					}
				}
			}
			return arr;
		}
		
		/**
		 * 根据屏幕象素坐标取得网格的坐标 
		 * @param px
		 * @param py
		 * @return 
		 * 
		 */		
		public static function getCellPoint(px:int, py:int):Point
		{
			var tileWidth:int = MapData.tileWidth ;
			var tileHeight:int = MapData.tileHeight;
			var xtile:int = 0;	//网格的x坐标
			var ytile:int = 0;	//网格的y坐标
			
			var cx:int, cy:int, rx:int, ry:int;
			cx = int(px / tileWidth) * tileWidth + tileWidth*0.5;	//计算出当前X所在的以tileWidth为宽的矩形的中心的X坐标
			cy = int(py / tileHeight) * tileHeight + tileHeight*0.5;//计算出当前Y所在的以tileHeight为高的矩形的中心的Y坐标
			
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
		public static function getPixelPoint(tx:int, ty:int):Point
		{
			//偶数行tile中心
			var tileCenter:int = (tx * MapData.tileWidth) + MapData.tileWidth*0.5;
			// x象素  如果为奇数行加半个宽
			var xPixel:int = tileCenter + (ty&1) * MapData.tileWidth*0.5;
			// y象素
			var yPixel:int = (ty + 1) * MapData.tileHeight*0.5;
			return new Point(xPixel, yPixel);
		}
		/**
		 * 根据点，获得此窗器中此点上的显示对象 
		 * @param container 容器
		 * @param point 此点的像素全局坐标
		 * @return  此显示对象的索引值
		 */		
		public static function getIndexByPoint(container:DisplayObjectContainer , point:Point):int 
		{
			for(var i:int = 0 ; i<container.numChildren ; i ++ ){
				var displayObj:DisplayObject = container.getChildAt(i);
				if(point.x==displayObj.x&&point.y==displayObj.y){
					return i;
				}
			}
			return -1;
		}
		/**
		 * 根据一个区域来查询对象的索引值 
		 * @param container
		 * @param point
		 * @return 
		 */		
		public static function getIndexByZone(container:DisplayObjectContainer , point:Point):int {
			var len:int = container.numChildren ;
			var index:int = -1;
			for(var i:int = len-1 ; i >=0 ; i--){
				var obj:DisplayObject = container.getChildAt(i) ;
				var pixel:Point = new Point(obj.x,obj.y); //屏幕坐标
				if( point.x>=pixel.x&& point.x<=pixel.x+obj.width&&point.y>=pixel.y&& point.y<=pixel.y+obj.height ){
					index = i;
					break;
				}
			}
			return index;
		}
	}
}