package utils
{
	import bing.utils.ObjectUtil;
	
	import enums.BuildingType;
	
	import map.elements.Building;
	import map.elements.Road;
	
	import models.vos.BuildingVO;

	/**
	 * 建筑简单工厂类 
	 * @author zhouzhanglin
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
			switch( vo.baseVO.type)
			{
				case BuildingType.ROAD:
					building = new Road( vo);
					break ;
				default:
					building = new Building( vo );
					break;
			}
			return building ;
		}
	}
}