package map
{
	import bing.iso.IsoObject;
	import bing.iso.IsoScene;
	
	import comm.GameSetting;
	
	import map.elements.Building;
	import map.elements.Building;
	
	import models.AStarRoadGridModel;
	import models.vos.BuildingVO;
	
	public class BuildingScene extends IsoScene
	{
		public function BuildingScene()
		{
			super(GameSetting.GRID_SIZE);
			mouseEnabled = mouseChildren = false ;
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
			if( obj.getWalkable(this.gridData) )
			{
				this.addIsoObject( obj );
				obj.setWalkable( false , this.gridData );
				obj.setWalkable(false, AStarRoadGridModel.instance.roadGrid );
				return obj;
			}
			return null ;
		}
		
		/**
		 * 添加建筑 
		 * @param building
		 * @return 
		 */		
		public function addBuilding( building:Building ):Building
		{
			this.addIsoObject( building );
			building.setWalkable( false , this.gridData );
			building.setWalkable(false, AStarRoadGridModel.instance.roadGrid );
			return building;
		}
		
		/**
		 * 移除建筑 
		 * @param building
		 */		
		public function removeBuilding( building:Building):void
		{
			building.setWalkable( true , this.gridData );
			building.setWalkable(true, AStarRoadGridModel.instance.roadGrid );
			this.removeIsoObject( building );
		}
		
		/**
		 * 旋转建筑 
		 * @param building
		 */		
		public function rotateBuilding( building:Building ):void
		{
			if(building.getRotatable(gridData))
			{
				building.setWalkable(true,gridData);
				building.scaleX = ~building.scaleX+1;
				building.drawGrid();
				building.setWalkable(false,gridData);
				building.sort();
			}
		}
		
		/**
		 * 清除数据和对象 
		 */		
		override public function clear():void
		{
			for each( var obj:IsoObject in children){
				obj.setWalkable( true , gridData );
				obj.setWalkable( true , AStarRoadGridModel.instance.roadGrid );
			}
			super.clear();
		}
	}
}