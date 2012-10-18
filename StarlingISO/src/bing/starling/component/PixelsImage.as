package bing.starling.component
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * 支持像素极检测的图片 
	 * @author zhouzhanglin
	 */	
	public class PixelsImage extends Image
	{
		private static var _basePoint:Point = new Point();
		/** alpha 检测阈值 */
		public var AlphaThreshold:int = 128 ;
		public var regionRect:Rectangle ;
		
		private var _srcBmd:BitmapData ;
		
		/**
		 * 构造
		 * @param texture 
		 * @param srcBmd Atlas图片
		 * @param regionRect 在Atlas图片上的位置
		 */		
		public function PixelsImage(texture:Texture , srcBmd:BitmapData , regionRect:Rectangle )
		{
			super(texture);
			this.regionRect = regionRect ;
			this._srcBmd = srcBmd ;
		}
		
		override public function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
		{
			var displayObj:DisplayObject = super.hitTest(localPoint,forTouch);
			if( displayObj){
				var temp:Point = localPoint.clone();
				temp.x += regionRect.x ;
				temp.y += regionRect.y ;
				if( _srcBmd.hitTest( _basePoint , AlphaThreshold , temp )){
					return this ;
				}
			}
			return null ;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_srcBmd = null ;
			regionRect = null ;
		}
	}
}