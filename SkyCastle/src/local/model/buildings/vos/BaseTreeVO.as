package local.model.buildings.vos
{
	/**
	 * 树的基本VO 
	 * @author zzhanglin
	 */	
	public class BaseTreeVO extends BaseDecorationVO
	{
		public function BaseTreeVO(){
			super();
			_file = "tree";
		}
		
		/** 每砍一次收获的木材数*/
		public var earnWoods:Array ;
		
		/** 每砍一次收获的金币数*/
		public var earnCoins:Array ;
		
		/** 每砍一次得到的经验值 */
		public var earnExps:Array ;
	}
}