package map.elements
{
	import models.vos.BuildingVO;
	
	public class Building extends BuildingBase
	{
		
		public function Building(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
		
		/** 发送添加到地图上的信息到服务器 */
		public function sendAddedToScene():void
		{
			buildingVO.nodeX = nodeX;
			buildingVO.nodeZ = nodeZ;
			//发送添加到地图上的信息到服务器
			
		}
		
		/** 旋转建筑 */
		public function sendRotatedBuilding():void
		{
			buildingVO.scale = this.scaleX; 
			//发送旋转到服务器
			
		}
		
		/** 发送移动建筑消息到服务器  */		
		public function sendMovedBuilding():void
		{
			buildingVO.nodeX = nodeX;
			buildingVO.nodeZ = nodeZ;
			//发送移动建筑消息到服务器
			
		}
		
		/** 发送收藏建筑的信息到服务器 */
		public function sendStashBuilding():void
		{
			//发送收藏建筑的信息到服务器
			
		}
	}
}