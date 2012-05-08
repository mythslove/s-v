package local.model.buildings.vos
{
	/**
	 * 农作物 
	 * @author zzhanglin
	 */	
	public class BasePlantVO extends BaseBuildingVO
	{
		public function BasePlantVO(){
			super();
			_file = "plant";
		}
		/**收获需要的时间*/
		public var earnTime:int ;
		
		/** 可以收获的金币数*/
		public var earnCoin:int ;
	}
}