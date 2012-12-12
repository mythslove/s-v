package bing.utils
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
		
		/**
		 * 判断点在多边形内  
		 * @param checkPoint 要判断的点
		 * @param dotPolygon 多边形的点的二维数组
		 * @return 
		 */		
		public static function checkPointInPolygon(checkPoint:Point, dotPolygon:Array):Boolean 
		{
			var nCount:uint = dotPolygon.length;
			if (nCount < 3) return false; //多边形不存在
			var isBeside:Boolean = false;//记录是否在多边形的边上
			
			var maxX:Number;
			var maxY:Number;
			var minX:Number;
			var minY:Number;
			var i:uint;
			
			maxX = dotPolygon[0][0];
			minX = dotPolygon[0][0];
			maxY = dotPolygon[0][1];
			minY = dotPolygon[0][1];
			for (i = 1; i < nCount; i++) {
				if (dotPolygon[i][0] >= maxX) {
					maxX = dotPolygon[i][0];
				} else if (dotPolygon[i][0] <= minX) {
					minX = dotPolygon[i][0];
				}
				
				if (dotPolygon[i][1] >= maxY) {
					maxY = dotPolygon[i][1];
				} else if (dotPolygon[i][1] <= minY) {
					minY = dotPolygon[i][1];
				}
			}
			if ((checkPoint.x > maxX) || (checkPoint.x < minX) || (checkPoint.y > maxY) || (checkPoint.y < minY)) {
				//return [-1, " ? "];//如果在多边形矩形区域外
			}
			
			var nCross:uint = 0;
			var p1:Array = new Array();
			var p2:Array = new Array();
			var vx, vy:Number;
			for (i = 0; i < nCount; i++) {
				p1 = dotPolygon[i];
				p2 = dotPolygon[(i + 1) % nCount];
				
				//求解 y=dot[1] 与 p1p2 的交点
				
				if (p1[1] == p2[1]) {// p1p2 与 y = dot[1] 平行
					if (checkPoint.y == p1[1] && checkPoint.x >= Math.min(p1[0], p2[0]) && checkPoint.x <= Math.max(p1[0], p2[0])) {
						isBeside = true;
						continue;
					}
				}
				
				if (checkPoint.y < Math.min(p1[1], p2[1]) || checkPoint.y > Math.max(p1[1], p2[1])) {// 交点在p1p2延长线上，包括 y=dot[1] 与 p1p2 平行的情形
					continue;
				}
				
				//求交点的 x 坐标，包括p1p2为垂直线的情形
				vx = (checkPoint.y - p1[1]) * (p2[0] - p1[0]) / (p2[1] - p1[1]) + p1[0];
				if (vx > checkPoint.x) {
					if (checkPoint.y == p1[1] || checkPoint.y == p2[1]) {
						if (checkPoint.y == Math.max(p1[1], p2[1])) {
							nCross ++;//y=dot[1] 与 p1p2 交于纵坐标较大的端点
						}
					} else {
						nCross ++;//只统计单侧交点
					}
				} else if (vx == checkPoint.x) {
					isBeside = true;
				}
			}
			if (isBeside) {
				return true ;//[0, nCross];//多边形边
			} else if (nCross % 2 == 1) {//单边交点为偶数，点在多边形之外
				return true ;//[1, nCross];//多边形内
			}
			return false ;//[-1, nCross];//多边形外
		}
	}
}