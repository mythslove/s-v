package  local.vo
{
	import local.comm.GameData;
	import local.comm.GlobalDispatcher;

	public class PlayerVO
	{
		public var dailyRewardsTime:Array; //[年，月，日]
		public var dailyRewards:int ;
		
		public var goods:int ; //物品，商品
		
		public var energy:int = 1 ; //能量
		public var maxEnergy:int = 20 ; //能量容量
		
		public var coin:int = 100; //金币数量
		public var cash:int = 10 ; //现金数量
		
		public var pop:int; //当前人口数量
		public var cap:int = 200 ; //人口容量
		
		public var level:int = 1 ; //玩家等级
		public var exp:int; //玩家当前经验值
		public var minExp:int ;
		public var maxExp:int = 150 ;
		
		
		public var tutorStep:int ; //新手指引当前步数
		
		
		
		//=====统计用==================
		public var runTime:Number = 0 ; //运行的时间
		public var loginTime:int = 0 ; //进游戏的次数
		public var monthLoginTime:int = 0 ;//每个月进游戏的次数
		public var playedDay:int = 0 ; //玩游戏的天数
		public var totalDay:int = 0 ;//玩游戏数的天数
		public var monthIap:Number =0 ;//一个月总共花费的钱
		public var todayIap:Number = 0 ;//今天花的钱
		public var totalIap:Number =0 ; //生涯中总共花的钱
		public var monthIapCount:int = 0 ;//一个月支付次数
		public var totalIapCount:int = 0 ;//总的支付次数
		//==========================
		
	}
}