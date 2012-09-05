package local.model
{
	import local.enum.BuildingType;
	import local.map.item.BaseBuilding;
	import local.vo.BuildingVO;
	import local.vo.StorageBuildingVO;

	/**
	 * 收藏箱数据 
	 * @author zhouzhanglin
	 */	
	public class StorageModel
	{
		private static var _instance:StorageModel;
		public static function get instance():StorageModel
		{
			if(!_instance) _instance = new StorageModel();
			return _instance; 
		}
		//=================================
		
		/** 收藏箱里房子 */
		public var homes:Vector.<BuildingVO>;
		
		/** 收藏箱里的装饰品 */
		public var decors:Vector.<StorageBuildingVO> ;
		
		/** 收藏箱里的商业建筑 */
		public var business:Vector.<StorageBuildingVO> ;
		
		/** 收藏箱里的工厂建筑 */
		public var industry:Vector.<StorageBuildingVO> ;
		
		/** 收藏箱里的奇迹建筑 */
		public var wonders:Vector.<StorageBuildingVO> ;
		
		/** 收藏箱里的交流中心建筑 */
		public var community:Vector.<StorageBuildingVO> ;
		
		/**
		 *  添加建筑到收藏箱
		 * @param baseBuilding
		 */		
		public function addBuildingToStorage( baseBuilding:BaseBuilding ):void
		{
			addBuildingVOToStorage( baseBuilding.buildingVO );
		}
		
		/**
		 * 添加一个建筑到收藏箱 
		 * @param buildingVO
		 */		
		public function addBuildingVOToStorage( buildingVO:BuildingVO ):void
		{
			var arr:Vector.<StorageBuildingVO> ;
			switch( buildingVO.baseVO.type  )
			{
				case BuildingType.DECO:
					if(!decors) decors = new Vector.<StorageBuildingVO>();
					arr = decors ;
					break ;
				case BuildingType.BUSINESS:
					if(!business) business = new Vector.<StorageBuildingVO>();
					arr = business ;
					break ;
				case BuildingType.COMMUNITY:
					if(!community) community = new Vector.<StorageBuildingVO>();
					arr = community ;
					break ;
				case BuildingType.HOME:
					if(!homes) homes = new Vector.<StorageBuildingVO>();
					arr = homes ;
					break ;
				case BuildingType.WONDERS:
					if(!wonders) wonders = new Vector.<StorageBuildingVO>();
					arr = wonders ;
					break ;
				case BuildingType.INDUSTRY:
					if(!industry) industry = new Vector.<StorageBuildingVO>();
					arr = industry ;
					break ;
			}
			var vo:StorageBuildingVO = getStorageVO( buildingVO.name );
			if(vo) {
				vo.num++;
			}else{
				vo = new StorageBuildingVO();
				vo.name = buildingVO.name ;
				vo.num = 1 ;
				vo.type = buildingVO.baseVO.type ;
				arr.push( vo );
			}
		}
		
		/**
		 * 删除一个StorageVO
		 * @param name
		 * @param type
		 */		
		public function deleteStorageVO( name :String , type:String ):void
		{
			var arr:Vector.<StorageBuildingVO> ;
			switch( type )
			{
				case BuildingType.DECO:
					arr = decors ;
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
					if(arr[i].name==name){
						arr[i].num--;
						if(arr[i].num==0){
							arr.splice( i , 1 );
						}
						break ;
					}
				}
			}
		}
		
		
		private function getStorageVO( name :String , arr:Vector.<StorageBuildingVO> ):StorageBuildingVO
		{
			for each( var vo:StorageBuildingVO in arr){
				if( vo.name ==name ) return vo ;
			}
			return null ;
		}
		
	}
}