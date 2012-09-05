package local.model
{
	import bing.ds.HashMap;
	import bing.iso.path.Grid;
	
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import local.comm.GameSetting;
	import local.map.item.BaseBuilding;
	import local.map.item.BaseMapObject;
	import local.util.EmbedsManager;

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
			var mapDataBytes:ByteArray = new EmbedsManager.MapData() as ByteArray ;
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
		
		/**
		 *  返回目标建筑旁边的所有建筑
		 * @param building 目标建筑
		 * @param type (BuildingType常量)只返回相应类型的建筑，如果为null，则返回所有
		 * @param subType 子类型
		 * @return 
		 */		
		public function getRoundBuildings( building:BaseBuilding , type:String=null , subType:String = null ):Array 
		{
			var xSpan:int = building.xSpan+building.nodeX ;
			var zSpan:int= building.zSpan+building.nodeZ ;
			var ii:int = building.nodeX-1 ;
			var jj:int = building.nodeZ-1 ;
			
			var nx:int ;
			var nz:int ;
			var arr:Array=[];
			var baseBuilding:BaseBuilding ;
			
			for( var i:int =ii ; i< xSpan ; ++i ){
				for( var j:int = jj ; j<zSpan; ++j){
					if( i==ii|| j==jj || i==xSpan || j==zSpan) 
					{
						if(_grid2Building.containsKey(i*GameSetting.GRID_SIZE+"-"+j*GameSetting.GRID_SIZE))
						{
							baseBuilding = _grid2Building.getValue(i*GameSetting.GRID_SIZE+"-"+j*GameSetting.GRID_SIZE) as BaseBuilding;
							if(type && type==baseBuilding.buildingVO.baseVO.type)
							{
								if(subType && subType==baseBuilding.buildingVO.baseVO.subClass){
									arr.push( baseBuilding );
								}
							}
							else
							{
								arr.push( baseBuilding );
							}
						}
					}
				}
			}
			return arr ;
		}
		
		public function clearBuildingGridData():void
		{
			_grid2Building.clear();
		}
		
	}
}