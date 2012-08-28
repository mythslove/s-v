package local.vos
{
	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * 位置动画资源 ，在二进制中，按照此属性的顺序写
	 * @author zhouzhanglin
	 */	
	public class BitmapAnimResVO
	{
		public var offsetX:int ; //偏移
		public var offsetY:int ;
		public var bmds:Vector.<BitmapData> ;
		public var isAnim:Boolean ;
		public var row:int ;
		public var col:int ;
		public var frame:int ;
		public var rate:int ;
		public var roads:Vector.<Point> ;
		
	}
}