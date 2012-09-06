package bing.animation
{
	import bing.ds.HashMap;
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * 循环资源完成事件 
	 */	
	[Event(name="animationComplete",type="bing.animation.AnimationEvent")]
	public class AnimationBitmap extends EventDispatcher implements IAnimatedBitmap
	{
		private var _currentFrame:int = 0  ; //当前帧
		private var _totalFrame:int = 0  ; //此动作的总帧
		private var _cycleTime:int = 0  ; //循环次数
		private var _rate:int = 0  ; //播放速率
		private var _playMode:int = 1  ; //播放模式
		private var _actions:Vector.<ActionVO> = null;  //所有的动作
		private var _animationBmd:BitmapData = null ; //当前帧的bitmapData
		private var _queueBmds:Vector.<BitmapData> = null  ; //所有的序列图
		private var _aniBmdHash:HashMap = null ; 
		private var _actionName:String ="" ; //当前的动作名称
		private var _isPlay:Boolean = true; //是否应该播放，用于停止和播放动画
		
		//临时变量========================
		private var _tempRate:int =0 ;
		private var _tempCycleTime:int = 0 ;
		private var _tempCircle:int =1 ;
		
		/**
		 * 构造函数  
		 * @param queueBmds 序列图片
		 * @param actions 所有的动作 
		 * @param rate 速率
		 * @param playMode 播放方式
		 */		
		public function AnimationBitmap( queueBmds:Vector.<BitmapData> , actions:Vector.<ActionVO>,rate:int = 3 , playMode:int =1 )
		{
			this._queueBmds = queueBmds ;
			this._actions = actions ;
			this._rate = rate ;
			this._playMode = playMode ;
			init();
		}
		/**
		 * 所动作的序列图关联起来 
		 */		
		private function init():void 
		{
			_aniBmdHash = new HashMap();
			var count:int =0 ;
			var tempQueueBmds:Vector.<BitmapData> ;
			for each( var actionVO:ActionVO in _actions)
			{
				tempQueueBmds = new Vector.<BitmapData>( actionVO.frameNum,true);
				for(var i:int = 0 ; i<actionVO.frameNum ; i++)
				{
					tempQueueBmds[i] = _queueBmds[count];
					count++;
				}
				_aniBmdHash.put( actionVO.actionName , tempQueueBmds);
			}
			_queueBmds = null ;
		}
		
		/** 添加额外的动作 */
		public function setExtAni( actionName:String , indexArray:Array ):void
		{
			var tempQueueBmds:Vector.<BitmapData>  = new Vector.<BitmapData>( indexArray.length,true);
			var len:int = indexArray.length ; 
			for( var i:int = 0 ; i<len ; ++i)
			{
				tempQueueBmds.push( _queueBmds[indexArray[i]] ) ;
			}
			_aniBmdHash.put( actionName , tempQueueBmds );
		}
		
		/**
		 * 从头开始播放动作 
		 * @param frame
		 */		
		public function start(frame:int=-1):void
		{
			if(frame>-1){
				_currentFrame = frame ;
			}else if( _currentFrame>_totalFrame ){
				_currentFrame = 0 ;
			}
			_tempRate = 0 ; 
			_isPlay = true ;
		}
		
		/**
		 * 停止播放 
		 */		
		public function stopAni():void
		{
			_isPlay = false ;
		}
		
		/**
		 * 播放动画 
		 * @param actionName 动作的名称
		 */		
		public function playAction(actionName:String ):void
		{
			if(!_isPlay) return ;
			
			if(_actionName!=actionName ) //判断是否应该改变动作
			{
				_actionName=actionName ;
				_queueBmds = _aniBmdHash.getValue( _actionName ) as Vector.<BitmapData>;
				_totalFrame = _queueBmds.length ;
				if( _playMode == AnimationPlayMode.POSITIVE ) 
				{
					this.start(0);
				}else if( _playMode == AnimationPlayMode.ANTITONE  ) {
					this.start(_totalFrame-1);
				}else{
					this.start(0);
				}
				_animationBmd = _queueBmds[currentFrame] ;
			}
			
			if( _playMode == AnimationPlayMode.POSITIVE ) //正序播放
			{
				playPositive() ;
			}else if( _playMode == AnimationPlayMode.ANTITONE  ) { //反序播放
				playAntitone();
			}else{
				playCirculation();  //循环反复播放
			}
		}
		
		/**
		 * 正序播放 
		 * @param actionName
		 */		
		private function playPositive():void
		{
			if(_tempRate==_rate)  //判断是否应该跳到下一帧
			{
				_animationBmd = _queueBmds[currentFrame] ;
				_tempRate = 0 ;
				_currentFrame++;
				if(_currentFrame>=_totalFrame) {
					_currentFrame =0 ; 
					checkCycleTime();
				}
			}
			_tempRate++;
		}
		
		/**
		 * 反序播放 
		 */		
		private function playAntitone():void
		{
			if(_tempRate==_rate)  //判断是否应该跳到下一帧
			{
				_animationBmd = _queueBmds[currentFrame] ;
				_tempRate = 0 ;
				_currentFrame--;
				if(_currentFrame<0 ) {
					_currentFrame = _totalFrame-1 ; 
					checkCycleTime();
				}
			}
			_tempRate++;
		}
		
		/**
		 * 来回反复播放 
		 */		
		private function playCirculation():void
		{
			if(_tempRate==_rate)  //判断是否应该跳到下一帧
			{
				_animationBmd = _queueBmds[currentFrame] ;
				_tempRate = 0 ;
				_currentFrame+=_tempCircle ;
				if(_tempCircle>0 ){
					if(_currentFrame>=_totalFrame) {
						_currentFrame = _totalFrame-2 ; 
						_tempCircle= -1 ;
					}
				}else{
					if(_currentFrame<0 ) {
						_currentFrame =1 ; 
						_tempCircle= 1 ;
					}
				}
				checkCycleTime();
			}
			_tempRate++;
		}
		
		/**
		 *判断此动作的循环次数 
		 */		
		private function checkCycleTime():void
		{
			if(_cycleTime>0)
			{
				_tempCycleTime++;
				if(_tempCycleTime==_cycleTime){
					this.dispatchEvent( new AnimationEvent( AnimationEvent.ANIMATION_COMPLETE )) ;
					_cycleTime =0 ;
					_tempCycleTime =0 ;
				}
			}
		}
		
		/**
		 * 切割图片 
		 * @param bmd
		 * @param row
		 * @param col
		 * @param frameNum 总数量，如果为0是row*col
		 * @return 
		 */		
		public static function splitBitmap(resBmd:BitmapData , row:int, col:int , frameNum:int =0   ):Vector.<BitmapData>
		{
			if(frameNum<=0)  frameNum = row*col ;
			
			var arr:Vector.<BitmapData> = new Vector.<BitmapData>(frameNum,true);
			var bmp:BitmapData ;
			var wid:int = Math.round( resBmd.width / col );
			var het:int = Math.round( resBmd.height / row );
			var rect:Rectangle = new Rectangle(0,0,wid,het);
			var count:int =0 ;
			for ( var i:int = 0 ; i<row ; i++)
			{
				for( var j:int = 0 ; j<col ; j++ )
				{
					bmp = new BitmapData( wid , het , true ,0xffffff );
					rect.x = j*wid ;
					rect.y = i*het ;
					bmp.copyPixels( resBmd , rect , new Point,null,null,true);
					arr[count] = bmp ;
					count++;
					if(count==frameNum) return arr ;
				}
			}
			return arr ;
		}
		
		/**
		 * 释放资源 
		 */		
		public function dispose():void
		{
			_queueBmds = null ;
			_animationBmd = null ;
			_aniBmdHash = null ;
			_actions = null ;
		}
		
		//===========getter/setter========================
		
		public function get currentFrame():int
		{
			if(this._currentFrame<0){
				return 0 ;
			}else if(this._currentFrame>_totalFrame-1){
				return _totalFrame-1 ;
			}
			return this._currentFrame ;
		}
		
		public function get totalFrame():int
		{
			return _totalFrame;
		}
		
		public function get animationBmd():BitmapData
		{
			return this._animationBmd;
		}
		
		public function set cycleTime(value:int):void
		{
			this._cycleTime = value ;
			this._tempCycleTime = 0 ;
		}
		
		public function get cycleTime():int
		{
			return this._cycleTime;
		}
		
		public function get actionName():String
		{
			return this._actionName;
		}
		
		public function get actions():Vector.<ActionVO>
		{
			return this._actions;
		}
		
		public function set rate(value:int):void
		{
			this._rate = value ;
			this._tempRate = 0 ;
		}
		
		public function get rate():int
		{
			return this._rate ;
		}
	}
}