package local.game.elements
{
	import local.model.buildings.vos.BaseStoneVO;
	import local.model.buildings.vos.BuildingVO;
	/**
	 * 装饰之石头 
	 * @author zzhanglin
	 */	
	public class Stone extends Decortation
	{
		public function Stone(vo:BuildingVO)
		{
			super(vo);
		}
		/** 获取此建筑的基础VO */
		public function get baseStoneVO():BaseStoneVO{
			return buildingVO.baseVO as BaseStoneVO ;
		}
	}
}