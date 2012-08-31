package  local.vo
{
	import local.comm.GameData;
	import local.comm.GlobalDispatcher;

	public class PlayerVO
	{
		public var minExp:int ;
		public var maxExp:int ;
		public var level:int;							//玩家等级
		public var dailyRewardsTime:Array; //[年，月，日]
		public var dailyRewards:int ;
		
		private var _fd:int;					//魔粉数量
		private var _cash:int;							//现金数量
		private var _pop:int;							//当前人口数量
		private var _experience:int;				//玩家当前经验值
		
	}
}