package local.game.elements
{
	import local.enum.MouseStatus;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.MouseManager;
	
	public class InteractiveBuilding extends BaseBuilding
	{
		public function InteractiveBuilding(vo:BuildingVO)
		{
			super(vo);
		}
		
		public function onClick():void
		{
			//判断当前建筑的状态，如果是收获，则执行收获；如果是修建，则执行修建。
		}
		
		public function onMouseOver():void
		{
			selectedStatus( true );
		}
		
		public function onMouseOut():void
		{
			selectedStatus( false );
			if(!MouseManager.instance.checkControl()){
				MouseManager.instance.mouseStatus = MouseStatus.NONE;
			}
		}
	}
}