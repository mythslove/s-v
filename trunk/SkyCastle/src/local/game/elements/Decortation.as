package local.game.elements
{
	import local.model.buildings.vos.BaseDecorationVO;
	import local.model.buildings.vos.BuildingVO;

	/**
	 * 装饰类建筑 
	 * @author zzhanglin
	 */	
	public class Decortation extends Building
	{
		public function Decortation(vo:BuildingVO)
		{
			super(vo);
		}
		/** 获取此建筑的基础VO */
		public function get baseDecorationVO():BaseDecorationVO{
			return buildingVO.baseVO as BaseDecorationVO ;
		}
	}
}