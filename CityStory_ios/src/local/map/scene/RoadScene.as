package local.map.scene
{
	import local.comm.GameSetting;
	import local.map.item.Road;
	import local.model.MapGridDataModel;

	/**
	 * 路，水层 
	 * @author zhouzhanglin
	 */	
	public class RoadScene extends BaseGroundScene
	{
		public function RoadScene()
		{
			super( GameSetting.GRID_SIZE , GameSetting.GRID_X , GameSetting.GRID_Z );
			mouseEnabled = false ;
			this.gridData = MapGridDataModel.instance.gameGridData ;
		}
		
		
		/**
		 *  添加对象
		 * @param road
		 * @param updatePos 是否更新方向
		 * @param isSort是否深度排序
		 */		
		public function addRoad( road:Road , updatePos:Boolean=true , isSort:Boolean=true ):void
		{
			this.addIsoObject( road , isSort );
			road.setWalkable( false , this.gridData );
			_groundNodeHash[road.nodeX+"-"+road.nodeZ]=road;
			MapGridDataModel.instance.addBuildingGridData(road);
			if(updatePos){
				updateUI(road);
			}
		}
		
		/**
		 * 移除对象
		 * @param road
		 */		
		public function removeRoad( road:Road):void
		{
			road.setWalkable( true , this.gridData );
			this.removeIsoObject( road );
			delete _groundNodeHash[road.nodeX+"-"+road.nodeZ];
			MapGridDataModel.instance.removeBuildingGridData(road);
			updateUI(road);
		}
		
	}
}