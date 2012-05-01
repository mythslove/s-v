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
		public var earnWood:int ;
		
		/** 每砍一次收获的金币数*/
		public var earnCoin:int ;
		
		/** 每砍一次得到的经验值 */
		public var earnExp:int ;
	}
}