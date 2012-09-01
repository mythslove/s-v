package  local.views.effects
{
	import bing.animation.ActionVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * 将MovieClip缓存为位图 
	 * @author zzhanglin
	 */	
	public class BitmapMovieClip extends Bitmap
	{
		public static const DEFAULT_ACTION:String = "defaultAction";
		
		
		protected var _currentFrame:int = 1 ;
		protected var _actionName:String = DEFAULT_ACTION ;
		protected var _actions:Dictionary = new Dictionary();
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
		public function getBound():Rectangle { return _bound; }
		public function get currentFrame():int { return _currentFrame ; }
		public function get totalFrame():int { return _mc.totalFrames ; }
		public function get currentLabel():String{ return _actionName ; } 
		
		private var _isPlaying:Boolean = true ;
		/** 是否在播放状态 */
		public function get isPlay():Boolean{ return _isPlaying; }
		
		private var _rate:int = 2 ;
		public function get rate():int{ return _rate ; }
		public function set rate(value:int):void{ _rate = _tempRate = value; }
		private var _tempRate:int=2 ;
		
		
		/**
		 * MovieClip缓存位图构造方法 
		 * @param mc 要缓存的影片
		 * @param bitmaps 已经缓存好的位图资源
		 * @param bounds 已经缓存好的位图位置
		 */		
		public function BitmapMovieClip( mc:MovieClip, bitmaps:Vector.<BitmapData>=null,bounds:Vector.<Rectangle> = null  , actions:Dictionary=null)
		{
			super();
			this._mc = mc ;
			this._bitmaps = bitmaps ;
			this._bounds = bounds ;
			this._actions = actions ;
			
			if(!_actions) configActions();
			
			var len:int = _mc.totalFrames;
			if(!_bitmaps) 	_bitmaps = new Vector.<BitmapData>(len,true);
			if(!_bounds)	_bounds = new Vector.<Rectangle>(len,true);
			gotoAndPlay(1);
		}
		
		
		private function configActions():void
		{
			_actions = new Dictionary(true);
			var frames:Array = _mc.currentLabels ;
			var len:int = frames.length ;
			if(len==0)
			{
				_actions[ DEFAULT_ACTION ] = new ActionVO( DEFAULT_ACTION , _mc.totalFrames , 1 , _mc.totalFrames ); 
			}
			else
			{
				var fl:FrameLabel ;
				var prevFl:FrameLabel ;
				for( var i:int = 1 ; i<len; ++i){
					prevFl = frames[i-1]  as FrameLabel
					fl = frames[i]  as FrameLabel ;
					_actions[ prevFl.name ] = new ActionVO(prevFl.name,fl.frame-prevFl.frame , prevFl.frame , fl.frame-1 ); 
				}
				_actions[ fl.name ] = new ActionVO(fl.name,_mc.totalFrames-fl.frame , fl.frame , _mc.totalFrames  ); 
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
			_mc.gotoAndStop(frame);
			_currentFrame = _mc.currentFrame ;
			update();
			_isPlaying = false ;
		}
		
		public function gotoAndPlay( frame:Object  , loopTime:int =  1 ):void
		{
			_tempLoopTime = 0 ;
			_rate = _tempRate  ;
			_loopTime = loopTime ;
			_mc.gotoAndStop(frame);
			_currentFrame = _mc.currentFrame ;
			if(_mc.currentLabel && _actionName!=_mc.currentLabel){
				_actionName = _mc.currentLabel ;
			}
			_isPlaying = true ;
		}
		
		public function stop():void
		{
			_tempLoopTime = 0 ; 
			_loopTime = 1 ;
			_isPlaying = false ;
		}
		
		public function play():Boolean
		{
			gotoAndPlay(1);
			return update();
		}
		
		/**
		 * 不断执行
		 * @return 图片是否更新，是否换了图片
		 */		
		public function update():Boolean
		{
			if(!_isPlaying) return false ;
			
			var result:Boolean ;
			++_tempRate;
			if(_tempRate>=_rate) 
			{
				_tempRate=0 ;
				
				if(_currentFrame>=_actions[_actionName].endFrame ){
					++_tempLoopTime ;
					if(_tempLoopTime==_loopTime){
						this.dispatchEvent( new Event(Event.COMPLETE)) ;
						//反复播放
						this.gotoAndPlay( _actionName , _loopTime );
						return result ;
					}
				}
				
				var temp:int = _currentFrame-1;
				if(!_bitmaps[temp]){
					_mc.gotoAndStop(_currentFrame);
					cacheAsBitmaps(temp);
				}
				if( bitmapData!=_bitmaps[temp] ){
					bitmapData = _bitmaps[temp];
					_bound =  _bounds[temp];
					result =  true ;
				}
			}
			++_currentFrame ;
			if(_currentFrame>_mc.totalFrames) {
				this.gotoAndPlay( _actionName , _loopTime );
			}
			
			return result ;
		}
		
		/**复制 */	
		public function clone():BitmapMovieClip{
			return new BitmapMovieClip(_mc,_bitmaps,_bounds,_actions);
		}
		
		/** 清除资源 */
		public function dispose():void
		{
			_mc.stop();
			_bitmaps = null ;
			_bounds = null ;
			_mc = null ;
			_actions = null ;
		}
	}
}