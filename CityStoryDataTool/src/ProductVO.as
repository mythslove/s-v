package
{
	/**
	 * Industry生产的商品 
	 * @author zhouzhanglin
	 */	
	public class ProductVO
	{
		public var name:String = "" ; //英语，唯一
		public var title:String = "" ; //多语言用
		public var time:int ; //要生产时间
		public var coinCost:int ; //要消耗的coin
		public var earnGoods:int ; //可以收获的 商品数量
		public var earnExp:int ;
	}
}