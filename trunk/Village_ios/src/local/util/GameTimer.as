package local.util
{
	import bing.utils.DateUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	[Event(name="complete",type="flash.events.Event")]
	public class GameTimer extends EventDispatcher
	{
		private var _duration:int ;
		/*持续时间*/
		public function get duration():int
		{
			return _duration>0?_duration:0;
		}
		private var _currentTime:int ;
		private var _tempTime:int ;
		private var _cha:int ;//时间差
		
		public function GameTimer(duration:int)
		{
			this._duration = duration ; 
			_currentTime = getTimer() ;
		}
		
		public function reset():void
		{
			_currentTime = 0 ;
			_tempTime = 0 ;
		}
		
		public function update():void 
		{
			_tempTime = getTimer();
			_cha = (_tempTime-_currentTime)*0.001 ;
			if(_cha>0)
			{
				_duration-=_cha;
				_currentTime = _tempTime ;
			}
			
			if(_duration<=0)
			{
				_duration =0 ;
				over();
			}
		}
		
		private function over():void 
		{
			this.dispatchEvent( new Event(Event.COMPLETE));
		}
		
		public function get timeString():String
		{
			return DateUtil.formatTimeToString(_duration);
		}
	}
}