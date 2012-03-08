package local.model.buildings.vos
{
	/**
	 * 房子的基本VO。由于房子是可以升级的，所以下面的大多数属性为数组 
	 * @author zzhanglin
	 */	
	public class BaseHouseVO extends BaseBuildingVO
	{
		public function BaseHouseVO(){
			super();
			_file = "house";
		}
		
		/** 每一等级可收获的金币数*/
		public var earnCoins:Array ;
		
		/** 每一等级可收获的经验值*/
		public var earnExps:Array ;
		
		/** 收获需要的时间*/
		public var earnTimes:Array ;
		
		/** 快速升级需要的钱*/
		public var upgradeCash:Array;
		
		/** 慢速升级所需要的金币数 */
		public var upgradeCoins:Array ;
		
		/** 慢速升级所需要的时间*/
		public var upgradeTimes:Array;
		
		/** 第一次修建时需要的木头数 */
		public var buildWood:int ;
		
		/** 第一次修建时需要的石头数*/
		public var buildStone:int ;
	}
}