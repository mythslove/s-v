package map
{
	import bing.iso.IsoObject;
	import bing.iso.IsoScene;
	
	import comm.GameSetting;
	
	import map.elements.BuildingBase;
	
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
		public function addBuildingByVO( dx:Number , dz:Number , buildingVO:BuildingVO ):BuildingBase
		{
			var obj:BuildingBase = new BuildingBase(buildingVO);
			obj.x = dx;
			obj.z = dz;
			if( obj.getWalkable(this.gridData) )
			{
				this.addIsoObject( obj );
				obj.setWalkable( false , this.gridData );
				obj.setWalkable(false, AStarRoadGridModel.instance.roadGrid );
				obj.drawGrid(); //显示占了的网格
				return obj;
			}
			return null ;
		}
		
		/**
		 * 添加建筑 
		 * @param buildingBase
		 * @return 
		 */		
		public function addBuilding( buildingBase:BuildingBase ):BuildingBase
		{
			this.addIsoObject( buildingBase );
			buildingBase.setWalkable( false , this.gridData );
			buildingBase.setWalkable(false, AStarRoadGridModel.instance.roadGrid );
			buildingBase.drawGrid(); //显示占了的网格
			return buildingBase;
		}
		
		/**
		 * 移除建筑 
		 * @param buildingBase
		 */		
		public function removeBuilding( buildingBase:BuildingBase):void
		{
			buildingBase.setWalkable( true , this.gridData );
			buildingBase.setWalkable(true, AStarRoadGridModel.instance.roadGrid );
			this.removeIsoObject( buildingBase );
		}
		
		/**
		 * 旋转建筑 
		 * @param buildingBase
		 */		
		public function roateBuilding( buildingBase:BuildingBase ):void
		{
			if(buildingBase.getRotatable(gridData))
			{
				buildingBase.setWalkable(true,gridData);
				buildingBase.scaleX = ~buildingBase.scaleX+1;
				buildingBase.drawGrid();
				buildingBase.setWalkable(false,gridData);
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