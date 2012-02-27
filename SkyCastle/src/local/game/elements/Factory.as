package local.game.elements
{
	import local.model.buildings.vos.BaseFactoryVO;
	import local.model.buildings.vos.BuildingVO;

	/**
	 * 工厂 
	 * @author zzhanglin
	 */	
	public class Factory extends Building
	{
		public function Factory(vo:BuildingVO)
		{
			super(vo);
		}
		/** 获取此建筑的基础VO */
		public function get baseFactoryVO():BaseFactoryVO{
			return buildingVO.baseVO as BaseFactoryVO ;
		}
	}
}