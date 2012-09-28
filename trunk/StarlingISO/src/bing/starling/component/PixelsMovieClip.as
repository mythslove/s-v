package bing.starling.component
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	
	/**
	 *  支持鼠标像素检测的动画
	 * @author zhouzhanglin
	 */	
	public class PixelsMovieClip extends MovieClip
	{
		private static var _basePoint:Point = new Point();
		/** alpha 检测阈值 */
		public var AlphaThreshold:int = 128 ;
		private var _srcBmd:BitmapData ;
		private var _regionRects:Vector.<Rectangle> ;
		
		/**
		 * 构造
		 * @param textures 
		 * @param srcBmd Atlas源图片
		 * @param regionRect Atlas源图片的区域
		 * @param fps 
		 */		
		public function PixelsMovieClip(textures:Vector.<Texture>, srcBmd:BitmapData , regionRect:Vector.<Rectangle> , fps:Number=12 )
		{
			super(textures, fps);
			this._srcBmd = srcBmd ;
			this._regionRects =  regionRect ;
		}
		
		
		override public function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
		{
			var displayObj:DisplayObject = super.hitTest(localPoint,forTouch);
			if( displayObj){
				var temp:Point = localPoint.clone();
				temp.x += _regionRects[currentFrame].x ;
				temp.y += _regionRects[currentFrame].y ;
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
			_regionRects = null ;
		}
	}
}