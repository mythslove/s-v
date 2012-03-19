package local.model.vos
{
	/**
	 * 奖励的内容 
	 * @author zhouzhanglin
	 */	
	public class RewardsVO
	{
		public var coin:int;
		public var gem:int ;
		public var exp:int ;
		public var wood:int ;
		public var stone:int ;
		public var buildings:Array; //建筑的基础id集合
		public var pickups:Array; //pickup名字集合
	}
}