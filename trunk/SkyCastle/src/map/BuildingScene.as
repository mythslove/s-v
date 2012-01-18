package map
{
	import bing.iso.IsoObject;
	import bing.iso.IsoScene;
	
	import comm.GameSetting;
	
	import map.elements.Building;
	
	import models.MapGridDataModel;
	import models.vos.BuildingVO;
	
	import utils.BuildingFactory;
	
	public class BuildingScene extends IsoScene
	{
		public function BuildingScene()
		{
			super(GameSetting.GRID_SIZE);
			this.gridData = MapGridDataModel.instance.buildingGrid ;
			mouseEnabled = false ;
		}
		
		/**
		 * 添加一个建筑  
		 * @param dx 建筑的位置
		 * @param dy 
		 * @param buildingVO
		 * @param isSort是否进行深度排序
		 * @return 添加成功返回true
		 */		
		public function addBuildingByVO( dx:Number , dz:Number , buildingVO:BuildingVO , isSort:Boolean=true ):Building
		{
			var building:Building = BuildingFactory.createBuildingByVO( buildingVO);
			building.x = dx;
			building.z = dz;
			return addBuilding(building,isSort);
		}
		
		/**
		 * 添加建筑 
		 * @param building
		 * @param isSort是否进行深度排序
		 * @return 
		 */		
		public function addBuilding( building:Building , isSort:Boolean=true ):Building
		{
			this.addIsoObject( building,isSort );
			building.setWalkable( false , gridData );
			//如果上面不能走
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
			building.setWalkable( true , gridData );
			building.setWalkable(true, MapGridDataModel.instance.astarGrid );
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
				//清除旋转前的数据
				building.setWalkable(true,gridData);
				building.setWalkable(true, MapGridDataModel.instance.astarGrid );
				//旋转
				building.scaleX = ~building.scaleX+1;
				//更新旋转后的数据
				building.drawGrid();
				building.setWalkable(false,gridData);
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
				obj.setWalkable( true , gridData );
				obj.setWalkable( true , MapGridDataModel.instance.astarGrid );
			}
			super.clear();
		}
	}
}