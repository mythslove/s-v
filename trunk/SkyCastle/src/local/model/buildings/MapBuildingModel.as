package local.model.buildings
{
	import local.enum.BuildingStatus;
	import local.enum.ItemType;
	import local.game.elements.Building;
	import local.model.buildings.vos.BaseBuildingVO;

	/**
	 * 地图上的所有建筑 
	 * @author zzhanglin
	 */	
	public class MapBuildingModel
	{
		private static var _instance:MapBuildingModel ;
		public static function get instance():MapBuildingModel
		{
			if(!_instance ) _instance = new MapBuildingModel();
			return _instance; 
		}
		//-------------------------------------------------------------------------
		
		/** 房子 */
		public var houses:Array = [];
		
		/** 工厂 */
		public var factories:Array = [] ;
		
		/** 其他装饰(除了路，石头，树)*/
		public var decroations:Array = [] ; 
		
		/** 路 */
		public var roads:Array = [];
		
		/** 农作物 */
		public var plants:Array = [] ;
		
		/** 基础数据：树*/
		public var trees:Array=[];
		
		/** 地图上所有的怪*/
		public var mobs:Array=[];
		
		/**
		 * 添加一个建筑到地图数据中 
		 * @param vo
		 */	
		public function addBuilding( building:Building ):void
		{
			var arr:Array  = getArrayByType( building.baseBuildingVO.type );
			if(arr )
			{
				arr.push( building );
			}
		}
		
		/**
		 * 从地图数据中移除一个建筑
		 * @param vo
		 */		
		public function removeBuilding( building:Building ):void
		{
			var arr:Array  = getArrayByType(  building.baseBuildingVO.type );
			if(arr){
				var len:int = arr.length ;
				for( var i:int = 0 ; i<len ; ++i)
				{
					if( arr[i] == building){
						arr.splice( i , 1 );
						break ;
					}
				}
			}
		}
		
		private function getArrayByType( type:String ):Array
		{
			var arr:Array ;
			switch( type )
			{
				case ItemType.BUILDING_HOUSE :
					arr = houses ;
					break ;
				case ItemType.BUILDING_FACTORY :
					arr = factories ;
					 break ;
				case ItemType.DECORATION :
					arr = decroations ;
					break ;
				case ItemType.DEC_ROAD :
					arr = roads ;
					break ;
				case ItemType.PLANT :
					arr = plants;
					break ;
				case ItemType.DEC_TREE:
					arr = trees;
					break ;
				case ItemType.MOB:
					arr = mobs ;
					break ;
			}
			return arr ;
		}
		
		//============统计地图上的建筑========================
		/**
		 * 统计建筑的数量，且baseId相同 
		 * @param baseId
		 * @return 
		 */	
		public function getCountByBaseId( baseId:String ):int
		{
			var baseVO:BaseBuildingVO = BaseBuildingVOModel.instance.getBaseVOById(baseId );
			var buildings:Array = getArrayByType(baseVO.type);
			var count:int ;
			for each(var build:Building in buildings){
				if(build.baseBuildingVO.baseId==baseId && build.buildingVO.buildingStatus!=BuildingStatus.BUILDING ) 
					++count ;
			}
			return count ;
		}
	}
}