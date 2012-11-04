package local.model
{
	import bing.iso.path.Grid;
	
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import local.comm.GameSetting;
	import local.map.item.BaseMapObject;
	import local.map.item.Floor;
	import local.map.item.Wall;
	import local.map.item.WallDecor;
	import local.map.item.WallPaper;
	import local.vo.PlayerVO;

	public class MapGridDataModel
	{
		private static var _instance:MapGridDataModel ;
		public static function get instance():MapGridDataModel
		{
			if(!_instance) _instance = new MapGridDataModel();
			return _instance;
		}
		//=======================================
		
		/** 游戏的数据 */
		public var gameGridData:Grid  ;
		
		/** 墙的Hash , key为nodeX-nodeZ-direction , value 为wall对象  */		
		private var _wallNodeHash:Dictionary = new Dictionary();
		
		private var _wallPaperHash:Dictionary = new Dictionary();
		
		private var _wallDecorHash:Dictionary = new Dictionary();
		
		private var _floorHash:Dictionary = new Dictionary();
		
		/**格子位置对建筑数据映射，当点击某个格子时，能知道当前点击了哪个建筑 */		
		private var _roomItemHash:Dictionary = new Dictionary();
		
		
		public function addWallGridData( wall:Wall ):void
		{
			var points:Vector.<Vector3D> = wall.spanPosition ;
			for each( var p:Vector3D in points) {
				_wallNodeHash[ p.x+"-"+p.z+"-"+wall.direction] = wall ;
			}
		}
		public function getWallByData( x:int,z:int,direction:int):Wall
		{
			return _wallNodeHash[x+"-"+z+"-"+direction] as Wall ;
		}
		
		
		
		
		
		
		public function MapGridDataModel()
		{
			gameGridData = new Grid( GameSetting.MAX_SIZE , GameSetting.MAX_SIZE ) ;
			var me:PlayerVO = PlayerModel.instance.me ;
			for( var i:int = 0 ; i<me.mapSize ; ++i ){
				for( var j:int = 0 ; j<me.mapSize ; ++j){
					gameGridData.setWalkable( i , j , true );
				}
			}
		}
		
		public function addRoomItemGridData( roomItem:BaseMapObject ):void
		{
			var points:Vector.<Vector3D> = roomItem.spanPosition ;
			for each( var p:Vector3D in points)
			{
				_roomItemHash[ p.x+"-"+p.z] = roomItem ;
			}
		}
		
		public function removeRoomItemGridData( roomItem:BaseMapObject ):void
		{
			var points:Vector.<Vector3D> = roomItem.spanPosition ;
			for each( var p:Vector3D in points)
			{
				delete _roomItemHash[ p.x+"-"+p.z] ;
			}
		}
		
		public function getRoomItemByData( x:int,z:int):BaseMapObject
		{
			return _roomItemHash[x+"-"+z] as BaseMapObject ;
		}
		
		
		/**
		 * 判断建筑周围是否有相应的建筑 
		 * @param building
		 * @param type
		 * @param subType
		 * @return  找到的话返回true , 否则返回false
		 */		
//		public function checkAroundBuilding( building:BaseItem , type:String , subType:String = null ):Boolean
//		{
//			var temp:BaseItem ;
//			//左上 , 
//			 var i:int = building.nodeZ ; var j:int = i+building.buildingVO.baseVO.span ;
//			for( i ; i<j ; ++i){
//				temp = _grid2Building.getValue( (building.nodeX-1)*GameSetting.GRID_SIZE+"-"+i*GameSetting.GRID_SIZE ) as BaseItem;
//				if( temp && temp.buildingVO.baseVO.type==type){
//					if(subType){
//						if(subType == temp.buildingVO.baseVO.subClass)	return true;
//					}else{
//						return true;
//					}
//				}
//			}
//			//左下
//			i = building.nodeX ; j=i+building.buildingVO.baseVO.span ;
//			for( i ; i<j ; ++i){
//				temp = _grid2Building.getValue( i*GameSetting.GRID_SIZE+"-"+ (building.nodeZ+building.buildingVO.baseVO.span)*GameSetting.GRID_SIZE ) as BaseItem;
//				if( temp && temp.buildingVO.baseVO.type==type){
//					if(subType){
//						if(subType == temp.buildingVO.baseVO.subClass)	return true;
//					}else{
//						return true;
//					}
//				}
//			}
//			//右上
//			i = building.nodeX ; j=i+building.buildingVO.baseVO.span ;
//			for( i ; i<j ; ++i){
//				temp = _grid2Building.getValue( i*GameSetting.GRID_SIZE+"-"+ (building.nodeZ-1)*GameSetting.GRID_SIZE ) as BaseItem;
//				if( temp && temp.buildingVO.baseVO.type==type){
//					if(subType){
//						if(subType == temp.buildingVO.baseVO.subClass)	return true;
//					}else{
//						return true;
//					}
//				}
//			}
//			//右下
//			i = building.nodeZ ; j = i+building.buildingVO.baseVO.span ;
//			for( i ; i<j ; ++i){
//				temp = _grid2Building.getValue( (building.nodeX+building.buildingVO.baseVO.span)*GameSetting.GRID_SIZE+"-"+i*GameSetting.GRID_SIZE ) as BaseItem;
//				if( temp && temp.buildingVO.baseVO.type==type){
//					if(subType){
//						if(subType == temp.buildingVO.baseVO.subClass)	return true;
//					}else{
//						return true;
//					}
//				}
//			}
//			return false;
//		}
		
		
		public function addWallPaperGridData( wallPaper:WallPaper ):void
		{
			var points:Vector.<Vector3D> = wallPaper.spanPosition ;
			for each( var p:Vector3D in points) {
				_wallPaperHash[ p.x+"-"+p.z+"-"+wallPaper.itemVO.direction] = wallPaper ;
			}
		}
		
		public function removeWallPaperGridData( wallPaper:WallPaper ):void
		{
			var points:Vector.<Vector3D> = wallPaper.spanPosition ;
			for each( var p:Vector3D in points) {
				delete _wallPaperHash[ p.x+"-"+p.z+"-"+wallPaper.itemVO.direction] ;
			}
		}
		
		public function getWallPaperByData( x:int,z:int,direction:int):WallPaper
		{
			return _wallPaperHash[x+"-"+z+"-"+direction] as WallPaper ;
		}
		
		
		
		
		
		
		public function addWallDecorGridData( wallDecor:WallDecor ):void
		{
			var points:Vector.<Vector3D> = wallDecor.spanPosition ;
			for each( var p:Vector3D in points) {
				_wallDecorHash[ p.x+"-"+p.z+"-"+wallDecor.itemVO..direction] = wallDecor ;
			}
		}
		
		public function removeWallDecorGridData( wallDecor:WallDecor ):void
		{
			var points:Vector.<Vector3D> = wallDecor.spanPosition ;
			for each( var p:Vector3D in points) {
				delete _wallDecorHash[ p.x+"-"+p.z+"-"+wallDecor.itemVO.direction] ;
			}
		}
		
		public function getWallDecorGridData( x:int,z:int,direction:int):WallDecor
		{
			return _wallDecorHash[x+"-"+z+"-"+direction] as WallDecor ;
		}
		
		
		
		
		
		
		
		
		
		public function addFloorGridData( floor:Floor ):void
		{
			var points:Vector.<Vector3D> = floor.spanPosition ;
			for each( var p:Vector3D in points) {
				_floorHash[ p.x+"-"+p.z] = floor ;
			}
		}
		
		public function removeFloorGridData( floor:Floor ):void
		{
			var points:Vector.<Vector3D> = floor.spanPosition ;
			for each( var p:Vector3D in points) {
				delete _floorHash[ p.x+"-"+p.z] ;
			}
		}
		
		public function getFloorGridData( x:int,z:int):Floor
		{
			return _floorHash[x+"-"+z] as Floor ;
		}
	}
}