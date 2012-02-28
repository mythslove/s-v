package local.game.elements
{
	import local.model.buildings.vos.BuildingVO;
	
	public class InteractiveBuilding extends BaseBuilding
	{
		public function InteractiveBuilding(vo:BuildingVO)
		{
			super(vo);
		}
		
		public function onClick():void
		{
			
		}
		
		public function onMouseOver():void
		{
			selectedStatus( true );
		}
		
		public function onMouseOut():void
		{
			selectedStatus( false );
		}
	}
}