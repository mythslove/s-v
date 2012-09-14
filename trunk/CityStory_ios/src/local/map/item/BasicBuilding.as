package local.map.item
{
	import local.vo.BuildingVO;

	/**
	 * 地图上基础建筑，主要是为了好看用的 
	 * @author zzhanglin
	 */	
	public class BasicBuilding extends Building
	{
		public function BasicBuilding( buildingVO:BuildingVO )
		{
			super(buildingVO);
		}
	}
}