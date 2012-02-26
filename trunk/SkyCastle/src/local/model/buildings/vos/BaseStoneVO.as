package local.model.buildings.vos
{
	/**
	 * 装饰基本类型之石头 
	 * @author zzhanglin
	 */	
	public class BaseStoneVO extends BaseDecorationVO
	{
		/** 每打击一次收获的石料数*/
		public var earnStones:Array ;
		
		/** 每打击一次收获的金币数*/
		public var earnCoins:Array ;
		
		/** 每打击一次花费的能量 */
		public var earnExps:Array ;
		
		/** 每打击一次花费的能量 */
		public var spendEnergys:Array;
		
		/** 可打击的次数 */
		public var earnStep:int ;
	}
}