package game.models.vos
{
	public class SlotItemVO
	{
		public var id:int ;
		public var url:String ; //老虎机的路径
		public var lines:int ; //总共有几条线
		public var icon:String; //图标
		public var enabled:Boolean; //是否可以用，不能用的显示coming soon
		public var minLevel:int; //最大等级限制，小于此等级的将是locked
		public var bets:Array ;//所有的倍率
	}
}