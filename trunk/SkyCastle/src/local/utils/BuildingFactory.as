package local.utils
{
	import bing.utils.ObjectUtil;
	
	import local.enum.ItemType;
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
				case ItemType.BUILDING:
					building = new Architecture(vo); //建筑
					break ;
				case ItemType.BUILDING_FACTORY: //工厂
					building = new Factory( vo );
					break ;
				case ItemType.BUILDING_HOUSE: //房子
					building = new House( vo );
					break ;
				case ItemType.DEC_TREE: //树
					building = new Tree( vo );
					break ;
				case ItemType.DEC_STONE: //石头
					building = new Stone( vo );
					break ;
				case ItemType.DEC_ROCK: //磐石
					building = new Rock( vo );
					break ;
				case ItemType.DEC_ROAD: //路
					building = new Road( vo );
					break ;
				case ItemType.DECORATION: //其他装饰
					building = new SpecialDecoration( vo );
					break ;
				case ItemType.PLANT: //种植类
					building = new Plant( vo );
					break ;
				case ItemType.MOB: //怪
					building = new Mob(vo);
					break ;
				default:
					building = new Building( vo );
					break ;
			}
			return building ;
		}
		
		
	}
}