package local.model.buildings.vos
{
	/**
	 * 种植类型之农作物，农作物生长有多个阶段
	 * 成熟后可以收获，收获后又到第一阶段 
	 * @author zzhanglin
	 */	
	public class BaseCropVO extends BasePlantVO
	{
		/** 生长的步数 */
		public var growSteps:Array ;
		
		/** 每生长一步需要的时间 ，最后一个时间为收获时间*/
		public var growTimes:Array ;
		
		/** 成熟后收获的钱*/
		public var earnCoin:int ;
		
		/** 成熟后收获的经验 */
		public var earnExp:int ;
		
	}
}