package local.map.item
{
	import local.enum.BuildingType;
	import local.model.MapGridDataModel;
	import local.vo.BuildingVO;
	
	public class Home extends Building
	{
		public function Home(buildingVO:BuildingVO)
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