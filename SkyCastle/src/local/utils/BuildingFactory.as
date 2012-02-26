package local.utils
{
	import bing.utils.ObjectUtil;
	
	import local.enum.BuildingType;
	import local.game.elements.Building;
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
				case BuildingType.DECORATION:
					break ;
			}
			return building ;
		}
	}
}