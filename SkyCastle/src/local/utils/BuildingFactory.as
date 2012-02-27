package local.utils
{
	import bing.utils.ObjectUtil;
	
	import local.enum.BuildingType;
	import local.game.elements.*;
	import local.model.buildings.vos.BuildingVO;

	/**
	 * 建筑的简单工厂类 ，通过BuildingVO来创建建筑
	 * @author zzhanglin
	 */	
	public class BuildingFactory
	{
		/**
		 * 通过buildingVO来创建建筑 
		 * @param vo
		 * @aparam isNew 如果是true，则先会对buildingVO进行深度复制
		 * @return 
		 */		
		public static function createBuildingByVO( vo:BuildingVO , isNew:Boolean=true ):Building
		{
			if(isNew) vo = ObjectUtil.copyObj(vo) as BuildingVO;
			var building:Building ;
			switch( vo.baseVO.type )
			{
				case BuildingType.BUILDING_FACTORY:
					building = new Factory( vo );
					break ;
				case BuildingType.BUILDING_HOUSE:
					building = new House( vo );
					break ;
				case BuildingType.DEC_TREE:
					building = new Tree( vo );
					break ;
				case BuildingType.DEC_STONE:
					building = new Stone( vo );
					break ;
				case BuildingType.DEC_ROAD:
					building = new Road( vo );
					break ;
				case BuildingType.DECORATION:
					building = new Decortation( vo );
					break ;
				default:
					building = new Building( vo );
					break ;
			}
			return building ;
		}
	}
}