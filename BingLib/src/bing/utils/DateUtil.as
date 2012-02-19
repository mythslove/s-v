package bing.utils
{
	/**
	 * 日期工具类 
	 * @author zhouzhanglin
	 * @date 2010/10/22
	 */	
	public class DateUtil
	{
		/**
		 * 获得年－月－日　时间 
		 * @return 
		 */		
		public static function getFullTime():String {
			var _date:Date = new Date();
			return _date.getHours()+":"+_date.getMinutes()+":"+_date.getSeconds()+","+_date.getMilliseconds();
			
		} 
		
		public static function formatTimeString(time:int):String
		{
			if (time == 0)
			{
				return "0sec";
			}else
			{
				var h:int = time / 3600;
				var m:int = time % 3600 / 60;
				var s:int = time % 3600 % 60;
				var hour:String = h > 0 ? h + "hr(s)" : "";
				var minute:String = m > 0 ? m + "min(s)" : "";
				var second:String = s > 0 ? s + "sec(s)" : "";
				return hour + minute + second;
			}
		}
		
		public static function formatTimeToString(time:int):String
		{
			if (time == 0)
			{
				return "0:00:00";
			}else
			{
				var h:int = time / 3600;
				var m:int = time % 3600 / 60;
				var s:int = time % 3600 % 60;
				var hour:String = h > 0 ? h + ":" : "0:";
				var minute:String = m > 0 ? String("0" + m).substr(-2, 2) + ":" : "00:";
				var second:String = s > 0 ? String("0" + s).substr(-2, 2) : "00";
				return hour + minute + second;
			}
		}
	}
}