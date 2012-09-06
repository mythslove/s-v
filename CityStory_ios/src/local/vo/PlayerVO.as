package  local.vo
{
	import local.comm.GameData;
	import local.comm.GlobalDispatcher;

	public class PlayerVO
	{
		public var dailyRewardsTime:Array; //[年，月，日]
		public var dailyRewards:int ;
		
		public var goods:int ; //物品，商品
		
		public var energy:int ; //能量
		public var maxEnergy:int ; //能量容量
		
		public var coin:int; //金币数量
		public var cash:int; //现金数量
		
		public var pop:int; //当前人口数量
		public var maxPop:int ; //最大人口数量
		
		public var level:int; //玩家等级
		public var exp:int; //玩家当前经验值
		public var minExp:int ;
		public var maxExp:int ;
		
	}
}