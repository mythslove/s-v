package local.model.buildings
{
	import local.enum.BuildingType;
	import local.game.elements.Plant;
	import local.model.buildings.vos.BaseBuildingVO;
	import local.model.buildings.vos.BuildingVO;

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
		
		/** 土地 */
		public var lands:Array = [] ;
		
		/** 农作物 */
		public var crops:Array = []
		
		/**
		 * 添加一个建筑到地图数据中 
		 * @param vo
		 */	
		public function addBuilding( vo:BuildingVO ):void
		{
			var arr:Array  = getArrayByType(  vo.baseVO.type );
			if(arr )
			{
				arr.push( vo );
			}
		}
		
		/**
		 * 从地图数据中移除一个建筑
		 * @param vo
		 */		
		public function removeBuilding( vo:BuildingVO ):void
		{
			var arr:Array  = getArrayByType(  vo.baseVO.type );
			if(arr){
				var len:int = arr.length ;
				for( var i:int = 0 ; i<len ; ++i)
				{
					if( arr[i] == vo){
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
				case BuildingType.BUILDING_HOUSE :
					arr = houses ;
					break ;
				case BuildingType.BUILDING_FACTORY :
					arr = factories ;
					 break ;
				case BuildingType.DECORATION :
					arr = decroations ;
					break ;
				case BuildingType.DEC_ROAD :
					arr = roads ;
					break ;
				case BuildingType.PLANT_LAND :
					break ;
				case BuildingType.PLANT_CROP :
					arr = crops ;
					break ;
			}
			return arr ;
		}
	}
}