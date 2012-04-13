package local.model.vos
{
	/**
	 * 收集物 
	 * @author zzhanglin
	 */	
	public class CollectionVO
	{
		public var groupId:String ; 
		
		public var title:String ;  //标题名称
		
		public var describe:String ; //描述
		
		public var pickups:Array ; //下面的一组 ,（5个一组）
		
		public var extra:RewardsVO; //额外的奖励
		
		/** 收集完成后，可以兑换的东西，取其中 三种 */
		public var exchangeWood:int ;
		public var exchangeStone:int ;
		public var exchangeXp:int ;
		public var exchangeCoin:int ;
		public var exchangeEnergy:int;
	}
}