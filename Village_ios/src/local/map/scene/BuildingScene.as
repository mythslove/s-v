package local.map.scene
{
	import bing.iso.IsoObject;
	import bing.iso.IsoScene;
	
	import local.comm.GameSetting;
	import local.map.item.BaseBuilding;
	import local.model.MapGridDataModel;
	
	/**
	 * 建筑层 
	 * @author zhouzhanglin
	 */	
	public class BuildingScene extends IsoScene
	{
		public function BuildingScene()
		{
			super(GameSetting.GRID_SIZE , GameSetting.GRID_X , GameSetting.GRID_Z );
			mouseEnabled = false ;
			this.gridData = MapGridDataModel.instance.gameGridData ;
		}
		
		
		/**
		 * 添加建筑 
		 * @param building
		 * @param isSort是否进行深度排序
		 * @return 
		 */		
		public function addBuilding( building:BaseBuilding , isSort:Boolean=true ):BaseBuilding
		{
			this.addIsoObject( building,isSort );
			building.setWalkable( false , gridData );
			MapGridDataModel.instance.addBuildingGridData(building);
			return building;
		}
		
		/**
		 * 移除建筑 
		 * @param building
		 */		
		public function removeBuilding( building:BaseBuilding):void
		{
			this.removeIsoObject( building );
			building.setWalkable( true , this.gridData );
			MapGridDataModel.instance.removeBuildingGridData(building);
		}
		
		/**
		 * 旋转建筑 
		 * @param buildingBase
		 */		
		public function rotateBuilding( building:BaseBuilding ):void
		{
			if(building.getRotatable(gridData))
			{
				building.setWalkable(true,gridData);
				MapGridDataModel.instance.removeBuildingGridData(building);
				building.scaleX = ~building.scaleX+1;
				building.setWalkable(false,gridData);
				MapGridDataModel.instance.addBuildingGridData(building);
			}
		}
		
		/**
		 * 准备保存 
		 */		
		public function readySave():void
		{
			var date:Date = new Date();
			var time:Number = date.time;
			var len:int = numChildren ;
			var build:BaseBuilding ;
			for( var i:int = 0 ; i<len ; ++i)
			{
				build = getChildAt( i ) as BaseBuilding ;
				if( build )
				{
					build.buildingVO.statusTime = 0 ;
					if( build.gameTimer){
						build.buildingVO.statusTime = time+build.gameTimer.duration*1000 ;
					}
				}
			}
		}
		
		/**
		 * 刷新建筑的状态 
		 */		
		public function refreshBuildingStatus():void
		{
			var len:int = numChildren ;
			var build:BaseBuilding ;
			for( var i:int = 0 ; i<len ; ++i)
			{
				build = getChildAt( i ) as BaseBuilding ;
				if( build ) {
					build.recoverStatus();
				}
			}
		}
		
		
		/**        排序算法           */
		override protected function sortCompare( target:IsoObject , item:IsoObject ):int
		{
			return target.screenY-item.screenY ;
		}
		
	}
}