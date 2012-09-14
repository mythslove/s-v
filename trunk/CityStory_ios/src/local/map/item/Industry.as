package local.map.item
{
	import local.comm.GameData;
	import local.enum.BuildingStatus;
	import local.enum.VillageMode;
	import local.vo.BuildingVO;
	
	public class Industry extends Building
	{
		public function Industry(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
		
		
		override public function onClick():void
		{
			if( GameData.villageMode==VillageMode.NORMAL)
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
			else
			{
				super.onClick();
			}
		}
	}
}