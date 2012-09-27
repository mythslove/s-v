package local.util
{
	import local.enum.BuildingType;
	import local.map.item.*;
	import local.vo.BaseBuildingVO;
	import local.vo.BuildingVO;

	/**
	 * 建筑简单工厂类 
	 * @author zhouzhanglin
	 */	
	public class BuildingFactory
	{
		/**
		 * 通过BuildingVO创建建筑 
		 * @param buildingVO
		 * @return 
		 */		
		public static function createBuildingByVO( buildingVO:BuildingVO ):BaseBuilding
		{
			var building:BaseBuilding ;
//			switch( buildingVO.baseVO.type)
//			{
//				case BuildingType.BASIC:
//					building = new BasicBuilding(buildingVO);
//					break ;
//				case BuildingType.DECORATION:
//					if(buildingVO.baseVO.subClass==BuildingType.DECORATION_ROAD || 
//						buildingVO.baseVO.subClass==BuildingType.DECORATION_GROUND)
//					{
//						building = new Road(buildingVO);
//					}else{
//						building = new BaseBuilding(buildingVO);
//					}
//					break ;
//				case BuildingType.BUSINESS:
//					building = new Business(buildingVO);
//					break ;
//				case BuildingType.INDUSTRY:
//					building = new Industry(buildingVO);
//					break ;
//				case BuildingType.HOME:
//					building = new Home(buildingVO);
//					break ;
//				case BuildingType.WONDERS:
//					building = new Community(buildingVO);
//					break ;
//				case BuildingType.COMMUNITY:
//					building = new Community(buildingVO);
//					break ;
//				case BuildingType.EXPAND_BUILDING:
//					building = new ExpandLandBuilding(buildingVO);
//					break ;
//				default:
//					building = new Building(buildingVO);
//					break ;
//			}
//			return building ;
		}
		
		/**
		 * 通过BaseBuildingVO 创建建筑 
		 * @param baseVO
		 * @return 
		 */		
		public static function createBuildingByBaseVO( baseVO:BaseBuildingVO ):BaseBuilding
		{
			var bvo:BuildingVO = new BuildingVO();
			bvo.name = baseVO.name ;
			bvo.baseVO = baseVO;
			return createBuildingByVO( bvo );
		}
	}
}