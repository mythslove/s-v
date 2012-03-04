package local.game.elements
{
	import local.model.buildings.vos.BaseRockVO;
	import local.model.buildings.vos.BuildingVO;
	/**
	 * 磐石，岩石，结合了石头和树的特点 
	 * @author zzhanglin
	 */	
	public class Rock extends Decortation
	{
		public function Rock(vo:BuildingVO)
		{
			super(vo);
		}
		
		/** 获取此建筑的基础VO */
		public function get baseTreeVO():BaseRockVO{
			return buildingVO.baseVO as BaseRockVO ;
		}
	}
}