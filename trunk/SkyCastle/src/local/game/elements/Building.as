package local.game.elements
{
	import local.model.buildings.vos.BuildingVO;
	
	public class Building extends BaseBuilding
	{
		public function Building(vo:BuildingVO)
		{
			super(vo);
		}
		
		/**
		 * 新建房子
		 */		
		public function sendAddBuilding():void
		{
			
		}
		
		/**
		 * 旋转建筑 
		 */		
		public function sendRotateBuilding():void
		{
			buildingVO.scale = scaleX ;
		}
		
		/**
		 * 移动建筑 
		 */		
		public function sendMoveBuilding():void
		{
			
		}
		
		/**
		 * 收藏 建筑
		 */		
		public function sendStashBuilding():void
		{
			
		}
		
	}
}