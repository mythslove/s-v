package local.map.item
{
	import local.enum.BuildingStatus;
	import local.enum.BuildingType;
	import local.model.MapGridDataModel;
	import local.vo.BuildingVO;
	
	public class Home extends Building
	{
		public function Home(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
		
		override public function onClick():void
		{
			if( buildingVO.status==BuildingStatus.PRODUCTION_COMPLETE)
			{
				//收钱
				
			}
			else
			{
				super.onClick();
			}
		}
	}
}