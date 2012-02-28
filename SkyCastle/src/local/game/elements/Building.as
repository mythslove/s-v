package local.game.elements
{
	import local.enum.BuildingOperation;
	import local.model.buildings.vos.BuildingVO;
	
	public class Building extends InteractiveBuilding
	{
		public function Building(vo:BuildingVO)
		{
			super(vo);
		}
		
		/**
		 * 发送操作到服务器
		 */		
		public function sendOperation( operation:String ):void
		{
			switch( operation )
			{
				case BuildingOperation.ADD:
					break ;
				case BuildingOperation.ROTATE:
					buildingVO.scale = scaleX ;
					break ;
				case BuildingOperation.STASH:
					break ;
				case BuildingOperation.MOVE:
					break ;
				case BuildingOperation.SELL :
					break ;
			}
		}
		
		
	}
}