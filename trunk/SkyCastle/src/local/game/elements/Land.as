package local.game.elements
{
	import local.model.buildings.vos.BaseLandVO;
	import local.model.buildings.vos.BuildingVO;

	/**
	 * 土地，继承自种植类 
	 * @author zzhanglin
	 */	
	public class Land extends Plant
	{
		public function Land(vo:BuildingVO)
		{
			super(vo);
		}
		/** 获取此建筑的基础VO */
		public function get baseLandVO():BaseLandVO{
			return buildingVO.baseVO as BaseLandVO ;
		}
	}
}