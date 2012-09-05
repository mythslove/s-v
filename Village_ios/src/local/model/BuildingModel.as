package local.model
{
	import local.enum.BuildingType;
	import local.map.item.BaseBuilding;
	import local.vo.BuildingVO;

	/**
	 * 地图上已经有的建筑 
	 * @author zzhanglin
	 */	
	public class BuildingModel
	{
		private static var _instance:BuildingModel;
		public static function get instance():BuildingModel
		{
			if(!_instance) _instance = new BuildingModel();
			return _instance; 
		}
		//=================================
		
		/** 基本的建筑 */
		public var basicTrees:Vector.<BuildingVO> ; 
		
		/** 家 */
		public var homes:Vector.<BuildingVO>;
		
		/** 装饰 */
		public var decorations:Vector.<BuildingVO>;
		
		/** 工厂*/
		public var industry:Vector.<BuildingVO> ;
		
		/** 商业*/
		public var business:Vector.<BuildingVO> ;
		
		/** 奇迹*/
		public var wonders:Vector.<BuildingVO> ;
		
		/** 交流场所 */
		public var community:Vector.<BuildingVO> ;
		
		public function addBuilding( baseBuilding:BaseBuilding ):void
		{
			addBuildingVO( baseBuilding.buildingVO ); 
		}
		
		public function addBuildingVO( vo:BuildingVO ):void
		{
			switch( vo.baseVO.type  )
			{
				case BuildingType.BASIC:
					if(!basicTrees) basicTrees = new Vector.<BuildingVO>();
					basicTrees.push( vo );
					break ;
				case BuildingType.DECO:
					if(!decorations) decorations = new Vector.<BuildingVO>();
					decorations.push( vo );
					break ;
				case BuildingType.BUSINESS:
					if(!business) business = new Vector.<BuildingVO>();
					business.push( vo );
					break ;
				case BuildingType.COMMUNITY:
					if(!community) community = new Vector.<BuildingVO>();
					community.push( vo );
					break ;
				case BuildingType.HOME:
					if(!homes) homes = new Vector.<BuildingVO>();
					homes.push( vo );
					break ;
				case BuildingType.WONDERS:
					if(!wonders) wonders = new Vector.<BuildingVO>();
					wonders.push( vo );
					break ;
				case BuildingType.INDUSTRY:
					if(!industry) industry = new Vector.<BuildingVO>();
					industry.push( vo );
					break ;
			}
		}
		
		public function removeBuilding( building:BaseBuilding ):void
		{
			removeBuildingVO( building.buildingVO );
		}
		
		public function removeBuildingVO( bvo:BuildingVO):void
		{
			var arr:Vector.<BuildingVO> ;
			switch( bvo.baseVO.type )
			{
				case BuildingType.BASIC:
					arr = basicTrees ;
					break ;
				case BuildingType.DECO:
					arr = decorations ;
					break ;
				case BuildingType.BUSINESS:
					arr = business ;
					break ;
				case BuildingType.COMMUNITY:
					arr = community ;
					break ;
				case BuildingType.HOME:
					arr = homes ;
					break ;
				case BuildingType.WONDERS:
					arr = wonders ;
					break ;
				case BuildingType.INDUSTRY:
					arr = industry ;
					break ;
			}
			if(arr){
				var len:int = arr.length ;
				for( var i:int = 0 ; i<len ; ++i ){
					if( arr[i] == bvo){
						arr.splice( i , 1 );
						break ;
					}
				}
			}
		}
	}
}