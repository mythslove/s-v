package map
{
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
		public function addBuilding( dx:Number , dz:Number , buildingVO:BuildingVO ):Boolean
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
				return true;
			}
			return false ;
		}
		
		/**
		 * 移除建筑 
		 * @param buildingBase
		 */		
		public function removeBuilding( buildingBase:BuildingBase):void
		{
			buildingBase.setWalkable( true , this.gridData );
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
	}
}