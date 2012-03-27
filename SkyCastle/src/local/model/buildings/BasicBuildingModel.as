package local.model.buildings
{
	import local.comm.GameRemote;
	import local.enum.ItemType;
	import local.model.buildings.vos.BuildingVO;

	/**
	 * 初始化地图数据 
	 * @author zzhanglin
	 */	
	public class BasicBuildingModel
	{
		private static var _instance:BasicBuildingModel ;
		public static function get instance():BasicBuildingModel
		{
			if(!_instance ) _instance = new BasicBuildingModel();
			return _instance; 
		}
		//-------------------------------------------------------------------------
		
		public var trees:Array =[];
		public var stones:Array = [] ;
		public var rocks:Array = [] ;
		
		public function addBuilding( buildingVO:BuildingVO ):void
		{
			switch( buildingVO.baseVO.type )
			{
				case ItemType.DEC_TREE:
					trees.push( buildingVO );
					break ;
				case ItemType.DEC_STONE:
					stones.push( buildingVO );
					break ;
				case ItemType.DEC_ROCK:
					rocks.push( buildingVO );
					break ;
			}
		}
		
		public function deleteBuilding( buildingVO:BuildingVO ):void
		{
			var arr:Array ;
			switch( buildingVO.baseVO.type )
			{
				case ItemType.DEC_TREE:
					arr = trees ;
					break ;
				case ItemType.DEC_STONE:
					arr = stones ;
					break ;
				case ItemType.DEC_ROCK:
					arr = rocks ;
					break ;
			}
			for( var i:int = 0 ; i <arr.length ; ++i)
			{
				if(arr[i] == buildingVO )
				{
					arr.splice( i , 1 );
					break ;
				}
			}
		}
		
		public function send():void
		{
			trace("发送修建");
			return ;
			var arr:Array = trees.concat(stones).concat(rocks) ;
			var ro:GameRemote = new GameRemote("mapservice");
			ro.getOperation("map").send(arr);
		}
	}
}