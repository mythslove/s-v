package local.game.elements
{
	import local.model.buildings.vos.BaseTreeVO;
	import local.model.buildings.vos.BuildingVO;
	/**
	 * 装饰之树，树藤 
	 * @author zzhanglin
	 */	
	public class Tree extends Decortation
	{
		public function Tree(vo:BuildingVO)
		{
			super(vo);
		}
		/** 获取此建筑的基础VO */
		public function get baseTreeVO():BaseTreeVO{
			return buildingVO.baseVO as BaseTreeVO ;
		}
	}
}