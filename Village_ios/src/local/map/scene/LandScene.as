package local.map.scene
{
	import bing.iso.path.Grid;
	
	import local.comm.GameSetting;
	import local.map.item.Land;
	import local.model.MapGridDataModel;

	/**
	 * 地图可用区域层 
	 * @author zhouzhanglin
	 */	
	public class LandScene extends BaseGroundScene
	{
		public function LandScene()
		{
			super(GameSetting.GRID_SIZE*4 , GameSetting.GRID_X/4 , GameSetting.GRID_Z/4 );
			mouseChildren = false ;
			this.gridData = new Grid( GameSetting.GRID_X/4 , GameSetting.GRID_Z/4 ) ;
		}
		
		
		/**
		 *  添加对象
		 * @param land
		 * @param updatePos 是否更新方向
		 * @return 
		 */		
		public function addLand( land:Land , updatePos:Boolean=true  ):void
		{
			this.addIsoObject( land );
			land.setWalkable( false , this.gridData );
			_groundNodeHash[land.nodeX+"-"+land.nodeZ]=land;
			if(updatePos){
				updateUI(land);
			}
			//将GameGridData的数据设置为可行
			var maxX:int = land.nodeX*4+4 ;
			var maxZ:int = land.nodeZ*4+4 ;
			var grid:Grid = MapGridDataModel.instance.gameGridData ;
			for( var i:int = land.nodeX*4 ; i<maxX ; ++i){
				for( var j:int = land.nodeZ*4 ; i<maxZ ; ++j){
					grid.setWalkable( i , j , true ) ;
				}
			}
		}
		
	}
}