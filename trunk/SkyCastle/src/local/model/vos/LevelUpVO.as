package local.model.vos
{
	/**
	 * 玩家升级 
	 * @author zzhanglin
	 */	
	public class LevelUpVO
	{
		//重新获取自己的信息，当同步
		public var me:PlayerVO ;
		//奖励
		public var rewardsVO:RewardsVO;
		
		public var shareTitle:String ;
		public var shareMsg:String ;
	}
}