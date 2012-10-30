package local.model
{
	import bing.ds.HashMap;
	import bing.iso.path.Grid;
	
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import local.comm.GameSetting;
	import local.map.item.BaseMapObject;
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
		
		/** 墙的Hash , key为nodeX-nodeZ-direction , value 为wall对象  */		
		public var wallNodeHash:Dictionary = new Dictionary();
		
		/** 游戏的数据 */
		public var gameGridData:Grid  ;
		
		/**格子位置对建筑数据映射，当点击某个格子时，能知道当前点击了哪个建筑 */		
		private var _grid2Building:HashMap = new HashMap();
		
		
		
		
		
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
		
		public function addBuildingGridData( building:BaseMapObject ):void
		{
			var points:Vector.<Vector3D> = building.spanPosition ;
			for each( var point:Vector3D in points)
			{
				var p:Vector3D = point.clone();
				_grid2Building.put( p.x+"-"+p.z , building );
			}
		}
		
		public function removeBuildingGridData( building:BaseMapObject ):void
		{
			var points:Vector.<Vector3D> = building.spanPosition ;
			for each( var point:Vector3D in points)
			{
				var p:Vector3D = point.clone();
				_grid2Building.remove( p.x+"-"+p.z );
			}
		}
		
//		public function getBuildingByData( x:int,z:int , subClass:String = null ):BaseBuilding
//		{
//			var build:BaseBuilding = _grid2Building.getValue(x+"-"+z) as BaseBuilding ;
//			if(build && subClass ){
//				if( build.buildingVO.baseVO.subClass==subClass) return build ; 
//				else return null ;
//			}
//			return build;
//		}
		
		public function getMapObject( x:int , z:int ):BaseMapObject
		{
			return  _grid2Building.getValue(x+"-"+z) as BaseMapObject ;
		}
		
		/**
		 * 判断建筑周围是否有相应的建筑 
		 * @param building
		 * @param type
		 * @param subType
		 * @return  找到的话返回true , 否则返回false
		 */		
//		public function checkAroundBuilding( building:BaseBuilding , type:String , subType:String = null ):Boolean
//		{
//			var temp:BaseBuilding ;
//			//左上 , 
//			 var i:int = building.nodeZ ; var j:int = i+building.buildingVO.baseVO.span ;
//			for( i ; i<j ; ++i){
//				temp = _grid2Building.getValue( (building.nodeX-1)*GameSetting.GRID_SIZE+"-"+i*GameSetting.GRID_SIZE ) as BaseBuilding;
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
//				temp = _grid2Building.getValue( i*GameSetting.GRID_SIZE+"-"+ (building.nodeZ+building.buildingVO.baseVO.span)*GameSetting.GRID_SIZE ) as BaseBuilding;
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
//				temp = _grid2Building.getValue( i*GameSetting.GRID_SIZE+"-"+ (building.nodeZ-1)*GameSetting.GRID_SIZE ) as BaseBuilding;
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
//				temp = _grid2Building.getValue( (building.nodeX+building.buildingVO.baseVO.span)*GameSetting.GRID_SIZE+"-"+i*GameSetting.GRID_SIZE ) as BaseBuilding;
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
		
		public function clearBuildingGridData():void
		{
			_grid2Building.clear();
		}
		
	}
}