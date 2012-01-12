package map
{
	import bing.iso.IsoObject;
	import bing.iso.IsoScene;
	
	import comm.GameSetting;
	
	import map.elements.Building;
	
	import models.MapGridDataModel;
	import models.vos.BuildingVO;
	
	public class BuildingScene extends IsoScene
	{
		public function BuildingScene()
		{
			super(GameSetting.GRID_SIZE);
			mouseEnabled = false ;
		}
		
		/**
		 * 添加一个建筑  
		 * @param dx 建筑的位置
		 * @param dy 
		 * @param buildingVO
		 * @return 添加成功返回true
		 */		
		public function addBuildingByVO( dx:Number , dz:Number , buildingVO:BuildingVO ):Building
		{
			var obj:Building = new Building(buildingVO);
			obj.x = dx;
			obj.z = dz;
			return addBuilding(obj);
		}
		
		/**
		 * 添加建筑 
		 * @param building
		 * @return 
		 */		
		public function addBuilding( building:Building ):Building
		{
			this.addIsoObject( building );
			building.setWalkable( false , MapGridDataModel.instance.buildingGrid );
			//有些建筑虽然在建筑层，但是可以从上面通过，如门，土地
			//如果上面不能走，将
			if( !building.buildingVO.baseVO.walkable ){ 
				building.setWalkable(false, MapGridDataModel.instance.astarGrid );
			}
			return building;
		}
		
		/**
		 * 移除建筑 
		 * @param building
		 */		
		public function removeBuilding( building:Building):void
		{
			building.setWalkable( true , MapGridDataModel.instance.buildingGrid );
			building.setWalkable(true, MapGridDataModel.instance.astarGrid );
			this.removeIsoObject( building );
		}
		
		/**
		 * 旋转建筑 
		 * @param building
		 */		
		public function rotateBuilding( building:Building ):void
		{
			var mapGrid:MapGridDataModel = MapGridDataModel.instance; 
			if(building.getRotatable(mapGrid.buildingGrid))
			{
				//清除旋转前的数据
				building.setWalkable(true,mapGrid.buildingGrid);
				building.setWalkable(true, MapGridDataModel.instance.astarGrid );
				//旋转
				building.scaleX = ~building.scaleX+1;
				//更新旋转后的数据
				building.drawGrid();
				building.setWalkable(false,mapGrid.buildingGrid);
				if( !building.buildingVO.baseVO.walkable ){ 
					building.setWalkable(false, MapGridDataModel.instance.astarGrid );
				}
				building.sort();
			}
		}
		
		/**
		 * 清除数据和对象 
		 */		
		override public function clear():void
		{
			for each( var obj:IsoObject in children){
				obj.setWalkable( true , MapGridDataModel.instance.buildingGrid );
				obj.setWalkable( true , MapGridDataModel.instance.astarGrid );
			}
			super.clear();
		}
	}
}