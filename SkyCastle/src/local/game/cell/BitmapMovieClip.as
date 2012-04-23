package local.game.cell
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
		public function getBound():Rectangle
		{
			return _bound;
		}
		
		public function get totalFrame():int{ return _mc.totalFrames; }
		public function get currentFrame():int{return _mc.currentFrame ;}
		
		public function get currentLabel():String{return _mc.currentLabel ;}
		public function get currentFrameLabel():String{return _mc.currentFrameLabel ;}
		
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
			
			var len:int = _mc.totalFrames;
			if(!_bitmaps) 	_bitmaps = new Vector.<BitmapData>(len,true);
			if(!_bounds)	_bounds = new Vector.<Rectangle>(len,true);
			gotoAndPlay(1);
		}
		
		/** 缓存成位图*/
		protected function cacheAsBitmaps( index:int ):void
		{
			var bmd:BitmapData;
			var rect:Rectangle ;
			var matrix:Matrix = new Matrix();
			//保存位置
			rect = _mc.getBounds(_mc);
			_bounds[index] = rect ;
			//保存图片
			matrix.identity();
			matrix.translate(-rect.x,-rect.y);
			bmd = new BitmapData(rect.width,rect.height,true,0xffffff);
			bmd.draw( _mc,matrix);
			_bitmaps[index] = bmd ;
		}
		
		public function gotoAndStop( frame:Object ):void
		{
			_mc.gotoAndStop(frame);
			update();
		}
		
		public function gotoAndPlay( frame:Object ):void
		{
			_mc.gotoAndPlay(frame);
			update();
		}
		
		public function stop():void
		{
			_mc.stop();
			update();
		}
		
		public function play():void
		{
			_mc.play();
			update();
		}
		
		public function update():void
		{
			var temp:int = _mc.currentFrame-1 ;
			if(!_bitmaps[temp]){
				cacheAsBitmaps(temp);
			}
			if(bitmapData!=_bitmaps[temp]){
				bitmapData = _bitmaps[temp];
				_bound =  _bounds[temp];
			}
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