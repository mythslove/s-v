package local.model.buildings.vos
{
	/**
	 * 工厂的基本VO，工厂可以产生木头，石头，钱等 
	 * @author zzhanglin
	 */	
	public class BaseFactoryVO extends BaseHouseVO
	{
		public function BaseFactoryVO(){
			super();
			_file = "factory";
		}
		
		
		/** 收获的木头*/
		public var earnWood:int ;
		
		/** 收获的石头*/
		public var earnStone:int ;
	}
}