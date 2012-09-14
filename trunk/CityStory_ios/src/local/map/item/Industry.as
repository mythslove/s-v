package local.map.item
{
	import local.enum.BuildingStatus;
	import local.vo.BuildingVO;
	
	public class Industry extends Building
	{
		public function Industry(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
		
		
		override public function onClick():void
		{
			if( buildingVO.status==BuildingStatus.LACK_MATERIAL)
			{
				
			}
			else if( buildingVO.status==BuildingStatus.PRODUCTION_COMPLETE)
			{
				
			}
			else
			{
				super.onClick();
			}
		}
	}
}