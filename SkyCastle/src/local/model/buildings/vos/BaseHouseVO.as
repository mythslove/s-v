package local.model.buildings.vos
{
	/**
	 * 房子的基本VO。房子只能收钱和经验
	 * @author zzhanglin
	 */	
	public class BaseHouseVO extends BaseBuildingVO
	{
		public function BaseHouseVO(){
			super();
			_file = "house";
		}
		
		
		
		
		
		
		
		/** 收获需要的时间*/
		public var earnTime:int ;
		
		/**可收获的金币数*/
		public var earnCoin:int ;
		
		/** 可收获的经验值*/
		public var earnExp:int ;
		
		
		
		
		
		/** 最大的等级，可以升到多少级，默认为1*/
		public var maxLevel:int ;
		
		
		
		
		
		/** 第一次修建时需要的木头数 */
		public var buildWood:int ;
		
		/** 第一次修建时需要的石头数*/
		public var buildStone:int ;
		
		/** 修建完成需要的材料 , 多个，key为pickupId , value为数量*/
		public var materials:Object ;
	}
}