package local.views.effects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
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
		
		private var _loopTime:int =1 ; //循环次数，在此次数上才抛出事件
		public function get loopTime():int { return _loopTime; }
		public function set loopTime(value:int):void {
			_loopTime = value;
			_tempLoopTime= 0;
		}
		private var _tempLoopTime:int ;
		
		protected var _bound:Rectangle =new Rectangle() ;
		public function getBound():Rectangle
		{
			return _bound;
		}
		
		
		private var _isPlaying:Boolean = true ;
		/** 是否在播放状态 */
		public function get isPlay():Boolean{
			return _isPlaying;
		}
		
		public function get totalFrame():int{ return _mc.totalFrames; }
		public function get currentFrame():int{return _mc.currentFrame ;}
		
		public function get currentLabel():String{return _mc.currentLabel ;}
		public function get currentFrameLabel():String{return _mc.currentFrameLabel ;}
		
		
		private var _rate:int = 3 ;
		public function get rate():int{ return _rate ; }
		public function set rate(value:int):void{ _rate = _tempRate = value }
		private var _tempRate:int=3 ;
		
		
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
			
			addEvt();
			
			var len:int = _mc.totalFrames;
			if(!_bitmaps) 	_bitmaps = new Vector.<BitmapData>(len,true);
			if(!_bounds)	_bounds = new Vector.<Rectangle>(len,true);
			gotoAndPlay(1);
		}
		
		
		private function addEvt():void
		{
			var frames:Array = _mc.currentLabels ;
			var len:int = frames.length ;
			var fl:FrameLabel ;
			for( var i:int = 1 ; i<len; ++i){
				fl = frames[i]  as FrameLabel ;
				_mc.addFrameScript(  fl.frame-2 , animationCompleteEvt );
			}
			_mc.addFrameScript( _mc.totalFrames-2 ,animationCompleteEvt); //最后一帧
		}
		
		private function animationCompleteEvt():void{
			_mc.gotoAndPlay(_mc.currentLabel);
			++_tempLoopTime;
			if(_tempLoopTime==loopTime)
			{
				this.dispatchEvent( new Event(Event.COMPLETE));
			}
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
			if(rect.width==0) rect.width =1 ;
			if(rect.height==0) rect.height =1 ;
			bmd = new BitmapData(rect.width,rect.height,true,0xffffff);
			bmd.draw( _mc,matrix);
			_bitmaps[index] = bmd ;
		}
		
		public function gotoAndStop( frame:Object ):void
		{
			_tempLoopTime = 0 ; 
			_mc.gotoAndStop(frame);
			update();
			_isPlaying = false ;
		}
		
		public function gotoAndPlay( frame:Object  , loopTime:int =  1 ):void
		{
			this.loopTime = loopTime;
			_mc.gotoAndPlay(frame);
			update();
			_isPlaying = true ;
		}
		
		public function stop():void
		{
			_tempLoopTime = 0 ; 
			_loopTime = 1 ;
			_mc.stop();
			update();
			_isPlaying = false ;
		}
		
		public function play():Boolean
		{
			_tempLoopTime = 0 ; 
			_loopTime = 1 ;
			_mc.play();
			_isPlaying = true ;
			return update();
		}
		
		public function update():Boolean
		{
			if(!_isPlaying) return false ;
			++_tempRate;
			if(_tempRate>=_rate) 
			{
				_tempRate=0 ;
				var temp:int = _mc.currentFrame-1 ;
				if(!_bitmaps[temp]){
					cacheAsBitmaps(temp);
				}
				if( bitmapData!=_bitmaps[temp] ){
					bitmapData = _bitmaps[temp];
					_bound =  _bounds[temp];
					return true ;
				}
			}
			return false ;
		}
		
		/**复制 */	
		public function clone():BitmapMovieClip{
			var clsName:String = flash.utils.getQualifiedClassName(_mc);
			var movie:MovieClip = new (getDefinitionByName(clsName) as Class)() as MovieClip ;
			var mc:BitmapMovieClip = new BitmapMovieClip(movie,_bitmaps,_bounds);
			return mc ;
		}
		
		/** 清除资源 */
		public function dispose( isDeep:Boolean=false ):void
		{
			_mc.stop();
			if(isDeep){
				_bitmaps = null ;
				_bounds = null ;
				_mc = null ;
			}
		}
	}
}