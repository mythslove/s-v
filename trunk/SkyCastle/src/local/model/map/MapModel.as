package local.model.map
{
	import bing.amf3.ResultEvent;
	
	import local.comm.GameRemote;
	import local.enum.ItemType;
	import local.game.GameWorld;
	import local.model.buildings.vos.BuildingVO;
	import local.model.map.vos.MapVO;

	/**
	 * 初始化地图数据 
	 * @author zzhanglin
	 */	
	public class MapModel
	{
		private static var _instance:MapModel ;
		public static function get instance():MapModel
		{
			if(!_instance ) _instance = new MapModel();
			return _instance; 
		}
		//-------------------------------------------------------------------------
		
		private var _ro:GameRemote;
		public function get ro():GameRemote
		{
			if(!_ro){
				_ro = new GameRemote("EditorService");
				_ro.addEventListener(ResultEvent.RESULT , onResultHandler );
			}
			return _ro ;
		}
		
		private var _mapVO:MapVO;
		public var trees:Array =[];
		public var stones:Array = [] ;
		public var rocks:Array = [] ;
		
		public function addBuilding( buildingVO:BuildingVO ):void
		{
			buildingVO.mapId = "MAP_01";
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
			if(!_mapVO){
				ro.getOperation("getConfig").send();
				return ;
			}
			var arr:Array = trees.concat(stones).concat(rocks) ;
			_mapVO.mapItems = arr ;
			ro.getOperation("saveConfig").send(_mapVO);
		}
		
		private function onResultHandler(e:ResultEvent):void
		{
			switch(e.method)
			{
				case "saveConfig":
					trace(e.result);
					break ;
				case "getConfig":
					_mapVO = e.result as MapVO ;
					if(_mapVO.mapItems){
						for each( var vo:BuildingVO in _mapVO.mapItems)
						{
							GameWorld.instance.addBuildingByVO(vo.nodeX,vo.nodeZ,vo,false,false);
							this.addBuilding( vo );
						}
						GameWorld.instance.buildingScene1.sortAll();
						GameWorld.instance.buildingScene2.sortAll();
						GameWorld.instance.buildingScene3.sortAll();
						GameWorld.instance.groundScene1.sortAll();
						GameWorld.instance.groundScene2.sortAll();
						GameWorld.instance.groundScene3.sortAll();
						GameWorld.instance.groundScene1.updateAllUI();
						GameWorld.instance.groundScene2.updateAllUI();
						GameWorld.instance.groundScene3.updateAllUI();
					}
					break ;
			}
		}
	}
}