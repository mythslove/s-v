package local.model.map
{
	import bing.amf3.ResultEvent;
	
	import local.comm.GameRemote;
	import local.enum.ItemType;
	import local.model.buildings.vos.BuildingVO;

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
			if(trees.length==0){
				ro.getOperation("getConfig").send();
				return ;
			}
			var arr:Array = trees.concat(stones).concat(rocks) ;
			var ro:GameRemote = new GameRemote("EditorService");
			ro.getOperation("saveConfig").send(arr);
		}
		
		private function onResultHandler(e:ResultEvent):void
		{
			switch(e.method)
			{
				case "saveConfig":
					trace(e.result);
					break ;
				case "getConfig":
					
					break ;
			}
		}
	}
}