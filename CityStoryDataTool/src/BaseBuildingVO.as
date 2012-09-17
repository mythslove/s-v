package 
{
	public class BaseBuildingVO
	{
		public var name:String="" ;
		public var title:String ="";//默认和name相同，用于不同语言包时
		public var span:int = 1 ; //占用的格子数
		public var type:String = "home" ; //主类型
		public var subClass:String="" ; //子类型
		
		public var buildComps:String ="" ; //修建时需要的 Compoents , URLVariable 格式, eg: Ticket=3&Flowers=6
		public var requirePop:int ; //购买时需要的人口要求
		public var requireLv:int ; //购买需要玩家的等级要求
		public var priceCoin:int ;//购买需要的金币
		public var priceCash:int ; //购买需要的钱/gem
		
		public var click:int ; //修建或砍树时的点击次数
		public var clickExp:int = 1; //修建或砍树时点击可以获得的经验
		
		public var goodsCost:int ; //生产需要的goods数量
		public var earnCoin:int ; //可以收获的钱
		public var earnExp:int ;//可以收获的经验
		public var earnComps:String = "";//会掉落的Componet , 格式 Ticket=3&TicketRate=0.2
		public var time:int ; //生产时间 
		
		public var addCap:int ;//可以增加多少人口容量
		public var addPop:int ; //可以增加多少人口
		
		public var products:Vector.<ProductVO> ; //可以生产的商品，主要用于industry
		public var expireTime:int ; //过期时间，用于industry
		
	}
}