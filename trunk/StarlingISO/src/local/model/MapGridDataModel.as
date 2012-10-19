package local.model
{
	import bing.ds.HashMap;
	import bing.iso.path.Grid;
	
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import local.comm.GameSetting;
	import local.map.item.BaseBuilding;
	import local.map.item.BaseMapObject;
	import local.util.EmbedManager;
	import local.util.ResourceUtil;

	public class MapGridDataModel
	{
		private static var _instance:MapGridDataModel ;
		public static function get instance():MapGridDataModel
		{
			if(!_instance) _instance = new MapGridDataModel();
			return _instance;
		}
		//=======================================
		
		/** 地图数据 ，哪些区域不能修东西 , 4*4的地块*/
		public var mapGridData:Grid ;
		public var mapPanX:int ;
		public var mapPanY:int ;
		
		public function MapGridDataModel()
		{
			//地图数据
			var mapDataBytes:ByteArray = ResourceUtil.instance.getResVOByResId("mapData").resObject as ByteArray ;
			mapPanX = mapDataBytes.readShort() ;  
			mapPanY = mapDataBytes.readShort() ;
			var maxX:int = mapDataBytes.readUnsignedByte() ;
			var maxZ:int = mapDataBytes.readUnsignedByte() ;
			GameSetting.GRID_X = maxX*4 ;
			GameSetting.GRID_Z = maxZ*4 ;
			mapGridData = new Grid(GameSetting.GRID_X , GameSetting.GRID_Z ) ;
			
			var flag:Boolean ;
			var p:int , k:int ;
			for(var i:int = 0 ; i<maxX ; ++i)
			{
				for(var j:int = 0 ; j<maxZ ; ++j)
				{
					flag = mapDataBytes.readBoolean() ;
					for( p = 0 ; p<4 ; ++p){
						for( k = 0 ; k<4 ; ++k){
							mapGridData.setWalkable(i*4+p , j*4+k , flag );
						}
					}
				}
			}
			
			landGridData = new Grid(GameSetting.GRID_X/4 , GameSetting.GRID_Z/4 ) ;
			gameGridData = new Grid( GameSetting.GRID_X , GameSetting.GRID_Z ) ;
			
			ResourceUtil.instance.deleteRes( "mapData" );
		}
		
		
		
		/** 玩家土地数据，表示玩家拥有哪几块地 */
		public var landGridData:Grid ;
		
		/** 游戏的数据 */
		public var gameGridData:Grid  ;
		
		/**格子位置对建筑数据映射，当点击某个格子时，能知道当前点击了哪个建筑 */		
		private var _grid2Building:HashMap = new HashMap();
		
		
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
		
		public function getBuildingByData( x:int,z:int , subClass:String = null ):BaseBuilding
		{
			var build:BaseBuilding = _grid2Building.getValue(x+"-"+z) as BaseBuilding ;
			if(build && subClass ){
				if( build.buildingVO.baseVO.subClass==subClass) return build ; 
				else return null ;
			}
			return build;
		}
		
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
		public function checkAroundBuilding( building:BaseBuilding , type:String , subType:String = null ):Boolean
		{
			var temp:BaseBuilding ;
			//左上 , 
			 var i:int = building.nodeZ ; var j:int = i+building.buildingVO.baseVO.span ;
			for( i ; i<j ; ++i){
				temp = _grid2Building.getValue( (building.nodeX-1)*GameSetting.GRID_SIZE+"-"+i*GameSetting.GRID_SIZE ) as BaseBuilding;
				if( temp && temp.buildingVO.baseVO.type==type){
					if(subType){
						if(subType == temp.buildingVO.baseVO.subClass)	return true;
					}else{
						return true;
					}
				}
			}
			//左下
			i = building.nodeX ; j=i+building.buildingVO.baseVO.span ;
			for( i ; i<j ; ++i){
				temp = _grid2Building.getValue( i*GameSetting.GRID_SIZE+"-"+ (building.nodeZ+building.buildingVO.baseVO.span)*GameSetting.GRID_SIZE ) as BaseBuilding;
				if( temp && temp.buildingVO.baseVO.type==type){
					if(subType){
						if(subType == temp.buildingVO.baseVO.subClass)	return true;
					}else{
						return true;
					}
				}
			}
			//右上
			i = building.nodeX ; j=i+building.buildingVO.baseVO.span ;
			for( i ; i<j ; ++i){
				temp = _grid2Building.getValue( i*GameSetting.GRID_SIZE+"-"+ (building.nodeZ-1)*GameSetting.GRID_SIZE ) as BaseBuilding;
				if( temp && temp.buildingVO.baseVO.type==type){
					if(subType){
						if(subType == temp.buildingVO.baseVO.subClass)	return true;
					}else{
						return true;
					}
				}
			}
			//右下
			i = building.nodeZ ; j = i+building.buildingVO.baseVO.span ;
			for( i ; i<j ; ++i){
				temp = _grid2Building.getValue( (building.nodeX+building.buildingVO.baseVO.span)*GameSetting.GRID_SIZE+"-"+i*GameSetting.GRID_SIZE ) as BaseBuilding;
				if( temp && temp.buildingVO.baseVO.type==type){
					if(subType){
						if(subType == temp.buildingVO.baseVO.subClass)	return true;
					}else{
						return true;
					}
				}
			}
			return false;
		}
		
		public function clearBuildingGridData():void
		{
			_grid2Building.clear();
		}
		
	}
}