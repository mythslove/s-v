package local.model.vos
{
	/**
	 * 树的基本VO 
	 * @author zzhanglin
	 */	
	public class BaseTreeVO extends BaseDecorationVO
	{
		/** 每砍一次收获的木材数*/
		public var earnWoods:Array ;
		
		/** 每砍一次收获的金币数*/
		public var earnCoins:Array ;
		
		/** 每砍一次花费的能量 */
		public var earnExps:Array ;
		
		/** 每砍一次花费的能量 */
		public var spendEnergys:Array;
		
		/** 可砍的次数 */
		public var earnStep:int ;
	}
}