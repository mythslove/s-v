package local.map.item
{
	import local.vo.BuildingVO;
	
	public class Building extends BaseBuilding
	{
		public function Building(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
		
		override public function update():void
		{
			super.update();
			if(buildingObject) {
				buildingObject.update() ;
			}
		}
	}
}