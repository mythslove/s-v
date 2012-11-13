package local.vo
{
	public class FoodVO
	{
		public var name:String="" ;
		public var requireLv:int ;
		public var costCash:int ;
		public var costCoin:int ;
		public var time:int ; //需要的时间
		public var earnFoods:int ; //可以收获的 商品数量
		public var earnCoin:int ; //可以收获的钱，每个顾客能收到的钱
		public var earnExp:int ;//可以收获的经验，每个顾客能收到的经验
		public var expireTime:int ; //过期时间
		public var materials:String ="" ;//需要的原料
	}
}