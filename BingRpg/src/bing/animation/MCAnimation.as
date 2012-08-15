package bing.animation
{
	import bing.ds.HashMap;
	
	import flash.display.BitmapData;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	/**
	 * 一个动作循环完成事件 
	 */	
	[Event(name="animationComplete",type="bing.animation.AnimationEvent")]
	public class MCAnimation extends MovieClip implements IAnimatedBitmap
	{
		private var _actionHash:HashMap ;
		private var _actionLable:AniLabel ;//当前的动作
		private var _actionName:String ;
		private var _currentFrame:int =1 ;
		private var _cycleTime:int=0 ;
		private var _isPlay:Boolean= true ;
		
		private var _tempCycleTime:int=0 ;
		
		public function MCAnimation()
		{
			super();
			getThisActions();
		}
		
		//此对象的所有标签动作
		private function getThisActions():void
		{
			var labels:Array = this.currentLabels;
			if(labels.length>0) _actionHash = new HashMap();
			else  return ;
			
			var label:FrameLabel ;
			var tempFrame:int = 0 ;
			var aniLabel:AniLabel ;
			for( var i:int =0 ; i<labels.length ; i++)
			{
				label = labels[i];
				if(aniLabel) 
				{
					aniLabel.maxFrame=label.frame-1 ;
				}
				aniLabel = new AniLabel();
				aniLabel.minFrame= label.frame ;
				aniLabel.label = label.name;
				_actionHash.put( label.name , aniLabel );
			}
			aniLabel.maxFrame = this.totalFrames ;
		}
		
		/**
		 * 从某一帧开始播放 
		 * @param frame   -1表示接着原来的地方播放
		 */		
		public function start( frame:int=-1 ):void 
		{
			_currentFrame = this._actionLable.minFrame ;
			_isPlay = true ; 
		}
		
		/**
		 *  返回当前动作已经播放到了第几帧
		 */		
		override public function get currentFrame():int 
		{
			return  _currentFrame;
		}
		
		/**
		 *  返回当前动作的总帧数
		 */		
		public function get totalFrame():int 
		{
			return	_actionLable.maxFrame-_actionLable.minFrame+1 ;
		}
		
		/**
		 * 当前是的BitmapData 
		 */		
		public function get animationBmd():BitmapData 
		{
			var bmd:BitmapData = new BitmapData( this.width,this.height,true,0xffffff );
			bmd.draw( this );
			return bmd ;
		}
		
		public function stopAni():void 
		{
			_isPlay = false ;
		}
		
		/**
		 * 动作的循环次数 
		 * @param value
		 */		
		public function set cycleTime( value:int ):void
		{
			this._cycleTime = value ;
			this._tempCycleTime = 0 ;
		}
		public function get cycleTime():int 
		{
			return this._cycleTime;	
		}
		
		/**
		 * 不断的播放，需要在enterFrame中不断调用 
		 * @param actionName 动作名称
		 */		
		public function playAction( actionName:String ):void
		{
			if(!_isPlay ) return ;
			
			if(_actionName!=actionName){
				_actionLable = _actionHash.getValue( actionName ) as AniLabel ;
				if(_actionLable){
					_actionName = _actionLable.label ;
					_currentFrame = _actionLable.minFrame ;
				}
			}
			else if(this._actionLable)
			{
				if(this.currentFrame==this._actionLable.maxFrame){
					_currentFrame = this._actionLable.minFrame ;
					if(_cycleTime>0){
						_tempCycleTime++;
						if(_tempCycleTime==_cycleTime){
							this.dispatchEvent( new AnimationEvent(AnimationEvent.ANIMATION_COMPLETE));
						}
					}
				}
				else
				{
					_currentFrame++;
				}
			}
			this.gotoAndStop( _currentFrame );
		}
			
		/**
		 * 当前的动作名称
		 */		
		public function get actionName():String 
		{
			return _actionName ;
		}
		
		/**
		 * 所有的动作集合
		 */		
		public function get actions():Vector.<ActionVO>
		{
			return null;
		}
		
		/**
		 * 播放的速率 
		 * @param value
		 */		
		public function set rate( value:int ):void {
		}
		public function get rate():int {
			return 0 ;
		}
		
		public function dispose():void{
			_actionHash = null ;
			_actionLable = null ;
		}
	}
}