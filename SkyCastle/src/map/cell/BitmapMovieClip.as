package map.cell
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * 将MovieClip缓存为位图 
	 * @author zzhanglin
	 */	
	public class BitmapMovieClip extends Bitmap
	{
		protected var _bitmaps:Vector.<BitmapData> ; //缓存的图片
		protected var _bounds:Vector.<Rectangle>; 
		protected var _mc:MovieClip;
		
		public function BitmapMovieClip( mc:MovieClip, bitmaps:Vector.<BitmapData>=null,bounds:Vector.<Rectangle> = null )
		{
			super();
			this._mc = mc ;
			this._bitmaps = bitmaps ;
			this._bounds = bounds ;
			if(!bitmaps){
				cacheAsBitmaps();
			}
		}
		
		/** 缓存成位图*/
		protected function cacheAsBitmaps():void
		{
			
		}
		
		/**复制 */	
		public function clone():BitmapMovieClip{
			var mc:BitmapMovieClip = new BitmapMovieClip(_mc,_bitmaps,_bounds);
			return mc ;
		}
		
		/** 清除资源 */
		public function dispose():void
		{
			_bitmaps = null ;
			_bounds = null ;
			_mc.stop();
			_mc = null ;
		}
	}
}