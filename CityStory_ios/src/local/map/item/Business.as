package local.map.item
{
	import local.comm.GameData;
	import local.enum.BuildingStatus;
	import local.enum.VillageMode;
	import local.vo.BuildingVO;
	
	public class Business extends Building
	{
		public function Business(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
		
		override public function onClick():void
		{
			if( GameData.villageMode==VillageMode.NORMAL)
			{
				if( buildingVO.status==BuildingStatus.LACK_MATERIAL)
				{
					flash(true);
				}
				else if( buildingVO.status==BuildingStatus.PRODUCTION_COMPLETE)
				{
					flash(true);
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