package local.map.item
{
	import local.enum.BuildingStatus;
	import local.vo.BuildingVO;
	
	public class Home extends Building
	{
		public function Home(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
		
		override public function onClick():void
		{
			super.onClick();
			if( buildingVO.status==BuildingStatus.PRODUCTION_COMPLETE)
			{
				//收钱
				
			}
		}
	}
}