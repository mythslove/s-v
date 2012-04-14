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
		
		public var pickups:Array ; //下面的一组 ,（5个一组）,pickupId数组
		
		/**额外的奖励 ,key为lv , value为RewardsVO */
		public var extras:Object; 
		
		/** key为lv , value为RewardsVO */
		public var exchanges:Object ;
	}
}