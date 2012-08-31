package local.model
{
	import bing.ds.HashMap;
	import bing.iso.path.Grid;
	
	import flash.geom.Vector3D;
	
	import local.comm.GameSetting;
	import local.map.item.BaseBuilding;

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
		public var gameGridData:Grid = new Grid( GameSetting.GRID_X , GameSetting.GRID_Z ) ;
		
		/**格子位置对建筑数据映射，当点击某个格子时，能知道当前点击了哪个建筑 */		
		private var _grid2Building:HashMap = new HashMap();
		
		
		public function addBuildingGridData( building:BaseBuilding ):void
		{
			var points:Vector.<Vector3D> = building.spanPosition ;
			for each( var point:Vector3D in points)
			{
				var p:Vector3D = point.clone();
				_grid2Building.put( p.x+"-"+p.z , building );
			}
		}
		
		public function removeBuildingGridData( building:BaseBuilding ):void
		{
			var points:Vector.<Vector3D> = building.spanPosition ;
			for each( var point:Vector3D in points)
			{
				var p:Vector3D = point.clone();
				_grid2Building.remove( p.x+"-"+p.z );
			}
		}
		
		public function getBuildingByData( x:int,z:int ):BaseBuilding
		{
			return _grid2Building.getValue(x+"-"+z) as BaseBuilding;
		}
		
		/**
		 *  返回目标建筑旁边的所有建筑
		 * @param building 目标建筑
		 * @param type (BuildingType常量)只返回相应类型的建筑，如果为null，则返回所有
		 * @return 
		 */		
		public function getRoundBuildings( building:BaseBuilding , type:String=null ):Array 
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
								arr.push( baseBuilding );
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