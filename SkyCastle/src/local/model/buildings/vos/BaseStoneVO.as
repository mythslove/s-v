package local.model.buildings.vos
{
	/**
	 * 装饰基本类型之石头 
	 * @author zzhanglin
	 */	
	public class BaseStoneVO extends BaseDecorationVO
	{
		public function BaseStoneVO(){
			super();
			_file = "stone";
		}
		
		/** 每打击一次收获的石料数*/
		public var earnStone:int ;
		
		/** 每打击一次收获的金币数*/
		public var earnCoin:int ;
		
		/** 每砍一次得到的经验值 */
		public var earnExp:int ;
	}
}