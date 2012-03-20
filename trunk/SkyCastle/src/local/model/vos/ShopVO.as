package local.model.vos
{
	/**
	 * 商店的 VO , 如果是建筑，则是ShopItemVO数组
	 * @author zzhanglin
	 */	
	public class ShopVO
	{
		public var buildings:Array;
		public var houses:Array ; //房子
		public var factorys:Array ; //工厂
		
		public var decorations:Array; //装饰
		public var roads:Array ; //路
		public var trees:Array;
		public var stones:Array;
		public var rocks:Array ;
		
		public var plants:Array; //农作物
		public var lands:Array ; //路
		public var crops:Array ; //作物
	}
}