package local.model.vos
{
	/**
	 * 奖励的内容 
	 * @author zhouzhanglin
	 */	
	public class RewardsVO
	{
		public var coin:int;
		public var cash:int ;
		public var exp:int ;
		public var wood:int ;
		public var stone:int ;
		public var energy:int ;
		public var buildings:Object ; //key-value，key为buildingBaseId , value 为数量
		public var pickups:Object; //key-value，key为pid , value为数量
		public var mob:Object  ; //返回的怪 {id:"", baseId:""}
	}
}