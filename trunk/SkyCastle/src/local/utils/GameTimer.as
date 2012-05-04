package local.utils
{
	import bing.utils.DateUtil;
	
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	import local.events.GameTimeEvent;
	
	
	[Event(name="timeOver",type="local.events.GameTimeEvent")]
	/**
	 * 游戏倒计时 
	 * @author zzhanglin
	 */	
	public class GameTimer extends EventDispatcher
	{
		//持续时间
		private var _duration:int ;
		private var _currentTime:int ;
		private var _tempTime:int ;
		private var _cha:int ;//时间差
		
		public function GameTimer(duration:int)
		{
			this._duration = duration ; 
			_currentTime = getTimer() ;
		}
		
		public function update():void 
		{
			_tempTime = getTimer();
			_cha = (_tempTime-_currentTime)/1000 ;
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
			this.dispatchEvent( new GameTimeEvent(GameTimeEvent.TIME_OVER));
		}
		
		public function get timeString():String
		{
			return DateUtil.formatTimeToString(_duration);
		}
	}
}