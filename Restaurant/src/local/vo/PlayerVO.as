package  local.vo
{
	import local.comm.GameSetting;
	

	public class PlayerVO
	{
		public var coin:int = 100; //金币数量
		public var cash:int = 10 ; //现金数量
		
		public var happy:int; //顾客满意值
		
		public var level:int = 1 ; //玩家等级
		public var exp:int; //玩家当前经验值
		public var minExp:int ;
		public var maxExp:int = 150 ;
		
		public var mapSize:int = GameSetting.DEFAULT_SIZE ; //玩家地图大小
		
		public var tutorStep:int ; //新手指引当前步数
	}
}