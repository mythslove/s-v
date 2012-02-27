package local.game.elements
{
	import local.model.buildings.vos.BaseRoadVO;
	import local.model.buildings.vos.BuildingVO;

	/**
	 * 路，草坪，水渠 
	 * @author zzhanglin
	 */	
	public class Road extends Decortation
	{
		public function Road(vo:BuildingVO)
		{
			super(vo);
		}
		/** 获取此建筑的基础VO */
		public function get baseRoadVO():BaseRoadVO{
			return buildingVO.baseVO as BaseRoadVO ;
		}
	}
}