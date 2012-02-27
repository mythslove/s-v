package local.game.elements
{
	import local.model.buildings.vos.BaseCropVO;
	import local.model.buildings.vos.BuildingVO;

	/**
	 * 农作物，继承自种植类 
	 * @author zzhanglin
	 */	
	public class Crop extends Plant
	{
		public function Crop(vo:BuildingVO)
		{
			super(vo);
		}
		
		/** 获取此建筑的基础VO */
		public function get baseCropVO():BaseCropVO{
			return buildingVO.baseVO as BaseCropVO ;
		}
	}
}