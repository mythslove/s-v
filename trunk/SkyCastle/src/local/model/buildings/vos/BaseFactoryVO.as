package local.model.buildings.vos
{
	/**
	 * 工厂的基本VO 
	 * @author zzhanglin
	 */	
	public class BaseFactoryVO extends BaseBuildingVO
	{
		public function BaseFactoryVO(){
			super();
			_file = "factory";
		}
		
		/** 可收获的金币数*/
		public var earnCoin:int ;
		
		/** 可收获的经验值*/
		public var earnExp:int ;
		
		/** 收获需要的时间*/
		public var earnTime:int ;
		
		/** 收获的木头*/
		public var earnWood:int ;
		
		/** 收藏的石头*/
		public var earnStone:int ;
		
		/** 修建需要花费的步数*/
		public var buildStep:int ;
		
		/** 修建一次需要花费的能量值 */
		public var buildSpendEnery:Array ;
		
		/** 第一次修建时需要的木头数 */
		public var buildWood:int ;
		
		/** 第一次修建时需要的石头数*/
		public var buildStone:int ;
	}
}