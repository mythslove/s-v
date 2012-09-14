package local.map.item
{
	import local.enum.BuildingStatus;
	import local.vo.BuildingVO;
	
	public class Wonder extends Building
	{
		public function Wonder(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
		
		override public function onClick():void
		{
			if( buildingVO.status==BuildingStatus.PRODUCTION_COMPLETE)
			{
				this.flash(true);
				//收钱
				
			}
			else
			{
				super.onClick();
			}
		}
	}
}