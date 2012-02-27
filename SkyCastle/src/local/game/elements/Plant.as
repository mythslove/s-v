package local.game.elements
{
	import local.model.buildings.vos.BasePlantVO;
	import local.model.buildings.vos.BuildingVO;

	/**
	 * 种植类建筑 
	 * @author zzhanglin
	 */	
	public class Plant extends Building
	{
		public function Plant(vo:BuildingVO)
		{
			super(vo);
		}
		/** 获取此建筑的基础VO */
		public function get basePlantVO():BasePlantVO{
			return buildingVO.baseVO as BasePlantVO ;
		}
	}
}