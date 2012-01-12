package map
{
	import bing.iso.IsoObject;
	import bing.iso.IsoScene;
	
	import comm.GameSetting;
	
	import enums.GridType;
	
	import map.elements.Building;
	
	import models.AStarRoadGridModel;
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
			building.setWalkable( false , this.gridData );
			
			//如果还要影响地面的数据格子(特殊情况)
			if( building.buildingVO.baseVO.gridType == GridType.GROUND ){ 
				var groundScene:GroundScene = GameWorld.instance.getGroundScene( building.nodeX , building.nodeZ );
				building.setWalkable( false , groundScene.gridData );
			}
			//有些建筑虽然在建筑层，但是可以从上面通过，如门，土地
			//如果上面不能走
			if( !building.buildingVO.baseVO.walkable ){ 
				building.setWalkable(false, AStarRoadGridModel.instance.roadGrid );
			}
			return building;
		}
		
		/**
		 * 移除建筑 
		 * @param building
		 */		
		public function removeBuilding( building:Building):void
		{
			building.setWalkable( true , this.gridData );
			//如果还要影响地面的数据格子(特殊情况)
			if( building.buildingVO.baseVO.gridType == GridType.GROUND ){ 
				var groundScene:GroundScene = GameWorld.instance.getGroundScene( building.nodeX , building.nodeZ );
				building.setWalkable( true , groundScene.gridData );
			}
			//如果上面不能走，移除地建筑的时候，将寻路数据设置为可行
			if( !building.buildingVO.baseVO.walkable ){
				building.setWalkable(true, AStarRoadGridModel.instance.roadGrid );
			}
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