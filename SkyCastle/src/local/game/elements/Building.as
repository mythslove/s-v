package local.game.elements
{
	import local.enum.BuildingOperation;
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