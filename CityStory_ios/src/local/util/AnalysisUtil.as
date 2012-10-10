package local.util
{
	import local.comm.GameData;
	import local.model.PlayerModel;
	import local.vo.PlayerVO;
	
//	import malka.extension.ios.flurry.FlurryAnalytics;

	/**
	 * 统计工具类 
	 * @author zhouzhanglin
	 * 
	 */
	public class AnalysisUtil
	{
//		public static var flurry:FlurryAnalytics ;
		
		public static function init():void
		{
			var me:PlayerVO = PlayerModel.instance.me; 
			me.loginTime++;
			me.monthLoginTime++ ;
			if(me.monthLoginTime==10||me.monthLoginTime==25||me.monthLoginTime==50||me.monthLoginTime==100)
			{
				send("Retention-Whale Tracking-"+me.monthLoginTime+" Sessions" , 
					{"Number of Purchases Total":me.totalIapCount , "Number of Purchases This Month":me.monthIapCount});
			}
			
			
			if(me.runTime==0) //游戏第一次初始化
			{
				me.runTime=GameData.commDate.time ;
				me.playedDay = 1 ;
				me.totalDay =1;
			}
			else
			{
				var value:int = (GameData.commDate.time-me.runTime)/86400000 ;
				if(value>0) //第二天
				{
					me.runTime = GameData.commDate.time;
					me.playedDay ++ ;
					me.totalDay+=value;
					//发送昨天的数据
					var tommo:int = me.playedDay-1 ;
					//Retention-DayX
					if(tommo==1||tommo==2||tommo==3||tommo==4||tommo==5||tommo==7||tommo==14||tommo==21||tommo==28){
						send("Retention-Day"+tommo , {"Sessions Played":me.loginTime , "Money Spend":me.todayIap});
					}
					me.todayIap = 0;
					if(me.totalDay%28==0) //下一个月
					{
						me.monthIapCount = 0 ;
						me.monthIap = 0 ;
						me.monthLoginTime = 1;
					}
				}
			}
			
		}
		
		public static function send(...param):void
		{
//			flurry.logEvent.apply(flurry, param);
			if(param.length==2){
				trace("EVENT:"+param[0]);
				for ( var key:String in param[1])
				{
					trace(key+":  "+param[1][key]);
				}
			}else trace("EVENT:"+param[0]);
			trace("------------------------------------------------------------");
		}
	}
}