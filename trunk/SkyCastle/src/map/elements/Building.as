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
			//发送添加到地图上的信息到服务器
			
		}
		
		/** 旋转建筑 */
		public function sendRotatedBuilding():void
		{
			//发送旋转到服务器
		}
		
		/** 发送移动建筑消息到服务器  */		
		public function sendMovedBuilding():void
		{
			//发送移动建筑消息到服务器
		}
	}
}