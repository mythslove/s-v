package local.map.item
{
	import local.comm.GameData;
	import local.enum.BuildingStatus;
	import local.enum.VillageMode;
	import local.vo.BuildingVO;
	
	public class Wonder extends Building
	{
		public function Wonder(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
		
		override public function onClick():void
		{
			if( GameData.villageMode==VillageMode.NORMAL)
			{
				if( buildingVO.status==BuildingStatus.PRODUCTION_COMPLETE)
				{
					flash(true);
					//收钱
					
				}
				else
				{
					super.onClick();
				}
			}
			else
			{
				super.onClick();
			}
		}
	}
}