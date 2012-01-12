package map.elements
{
	import bing.iso.IsoScene;
	
	import map.BuildingScene;
	import map.GroundScene;
	
	import models.MapGridDataModel;
	import models.vos.BuildingVO;
	
	public class Building extends BuildingBase
	{
		public function Building(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
		
		
		/** 发送添加到地图上的信息到服务器 */
		public function addedToMap():void
		{
			//发送添加到地图上的信息到服务器
			
		}
		
		/** 旋转建筑 */
		public function rotateBuilding():void
		{
			if(this.getRotatable( MapGridDataModel.instance.buildingGrid) )
			{
				var isoScene:IsoScene = this.parent as IsoScene ;
				if(isoScene is BuildingScene)
				{
					(isoScene as BuildingScene).removeBuilding( this );
					this.scaleX = ~this.scaleX+1 ;
					(isoScene as BuildingScene).addBuilding( this );
				}
				else if(isoScene is GroundScene)
				{
					(isoScene as GroundScene).removeBuilding( this );
					this.scaleX = ~this.scaleX+1 ;
					(isoScene as GroundScene).addBuilding( this );
				}
				//发送旋转到服务器
			}
		}
	}
}