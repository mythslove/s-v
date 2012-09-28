package local.vo
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import starling.textures.Texture;

	/**
	 * 位置动画资源 ，在二进制中，按照此属性的顺序写
	 * @author zhouzhanglin
	 */	
	public class BitmapAnimResVO
	{
		public var offsetX:int ; //偏移
		public var offsetY:int ;
		public var bmds:Vector.<BitmapData> ;
		public var textures:Vector.<Texture> ;
		public var isAnim:Boolean ;
		public var row:int ;
		public var col:int ;
		public var frame:int ;
		public var rate:int ;
		public var roads:Vector.<Point> ;
		
	}
}