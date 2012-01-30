package map.cell
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * 将MovieClip缓存为位图 
	 * @author zzhanglin
	 */	
	public class BitmapMovieClip extends Bitmap
	{
		protected var _bitmaps:Vector.<BitmapData> ; //缓存的图片
		protected var _bounds:Vector.<Rectangle>; 
		protected var _mc:MovieClip;
		
		protected var _bound:Rectangle =new Rectangle() ;
		public function get bound( target:DisplayObjectContainer ):Rectangle
		{
			var rect:Rectangle = _bound.clone();
			rect.x-=target.x ;
			rect.y-=target.y ;
			return rect;
		}
		
		/**
		 * MovieClip缓存位图构造方法 
		 * @param mc 要缓存的影片
		 * @param bitmaps 已经缓存好的位图资源
		 * @param bounds 已经缓存好的位图位置
		 */		
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
			const LEN:int = _mc.totalFrames;
			_bitmaps = new Vector.<BitmapData>(LEN,true);
			_bounds = new Vector.<Rectangle>(LEN,true);
			var bmd:BitmapData;
			var rect:Rectangle ;
			var matrix:Matrix = new Matrix();
			for( var i:int = 0 ; i<LEN ; ++i){
				_mc.gotoAndStop(i+1);
				//保存位置
				rect = _mc.getBounds(_mc);
				_bounds[i] = rect ;
				//保存图片
				matrix.identity();
				matrix.translate(-rect.x,-rect.y);
				bmd = new BitmapData(rect.width,bmd.height,true,0xffffff);
				bmd.draw( _mc,matrix);
				_bitmaps[i] = bmd ;
			}
		}
		
		public function gotoAndStop( frame:Object ):void
		{
			this._mc.gotoAndStop(frame);
			update();
		}
		
		public function gotoAndPlay( frame:Object ):void
		{
			this._mc.gotoAndPlay(frame);
			update();
		}
		
		public function stop():void
		{
			this._mc.stop();
			update();
		}
		
		public function play():void
		{
			this._mc.play();
			update();
		}
		
		public function update():void
		{
			this.bitmapData = this._bitmaps[_mc.currentFrame-1];
			_bound =  this._bounds[_mc.currentFrame-1];
		}
		
		/**复制 */	
		public function clone():BitmapMovieClip{
			var clsName:String = flash.utils.getQualifiedClassName(_mc);
			var movie:MovieClip = new (getDefinitionByName(clsName) as Class)() as MovieClip ;
			var mc:BitmapMovieClip = new BitmapMovieClip(movie,_bitmaps,_bounds);
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