package bing.starling.component
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class PixelsImage extends Image
	{
		public var AlphaThreshold:int = 128 ;
		
		private var _srcBmd:BitmapData ;
		private static var _basePoint:Point = new Point();
		private var _regionRect:Rectangle ;
		
		public function PixelsImage(texture:Texture , srcBmd:BitmapData , regionRect:Rectangle )
		{
			super(texture);
			this._regionRect = regionRect ;
			this._srcBmd = srcBmd ;
		}
		
		override public function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
		{
			var displayObj:DisplayObject = super.hitTest(localPoint,forTouch);
			if( displayObj){
				var temp:Point = localPoint.clone();
				temp.x += _regionRect.x ;
				temp.y += _regionRect.y ;
				if( _srcBmd.hitTest( _basePoint , AlphaThreshold , temp )){
					return this ;
				}
			}
			return null ;
				
		}
	}
}