package local.model.buildings.vos
{
	/**
	 * 磐石，岩石 ，结合了石头和树的特点
	 * @author zzhanglin
	 */	
	public class BaseRockVO extends BaseDecorationVO
	{
		public function BaseRockVO(){
			super();
			_file = "rock";
		}
		
		/** 每砍一次收获的木材数*/
		public var earnWood:int ;
		
		/** 每打击一次收获的石料数*/
		public var earnStone:int ;
		
		/** 每砍一次收获的金币数*/
		public var earnCoin:int ;
		
		/** 每砍一次获得的经验值*/
		public var earnExp:int ;
	}
}