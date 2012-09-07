package local.map.item
{
	import local.enum.BuildingType;
	import local.model.MapGridDataModel;
	import local.vo.BuildingVO;
	
	public class Building extends BaseBuilding
	{
		public function Building(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
		
		override public function addToSceneFromTopScene():void
		{
			super.addToSceneFromTopScene();
			trace("周围是否有路："+MapGridDataModel.instance.checkAroundBuilding(this,BuildingType.DECORATION,BuildingType.DECORATION_ROAD));
		}
	}
}