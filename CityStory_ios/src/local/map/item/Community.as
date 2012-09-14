package local.map.item
{
	import local.enum.BuildingStatus;
	import local.vo.BuildingVO;
	
	public class Community extends Building
	{
		public function Community(buildingVO:BuildingVO)
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