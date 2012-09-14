package local.view.bottombar
{
	import flash.display.MovieClip;
	
	import local.comm.GameData;
	import local.enum.BuildingStatus;
	import local.enum.BuildingType;
	import local.enum.VillageMode;
	import local.map.item.BaseBuilding;

	/**
	 * 游戏的tip 
	 * @author zhouzhanglin
	 */	
	public class GameTip extends MovieClip
	{
		public function GameTip()
		{
			super();
			stop();
			mouseEnabled = false ;
		}
		
		
		public function showBuildingTip( building:BaseBuilding ):void
		{
			if( GameData.villageMode==VillageMode.NORMAL){ 
				// 如果是修建状态
				switch( building.buildingVO.status)
				{
					case BuildingStatus.NO_ROAD: //没路时，显示移动建筑提示 
						break ;
					case BuildingStatus.EXPANDING: //扩地时，显示instant提示
						
						break ;
					case BuildingStatus.PRODUCTION: //生产时，显示instant提示
						
						break ;
					case BuildingStatus.PRODUCTION_COMPLETE:
						
						break ;
					case BuildingStatus.LACK_MATERIAL: //没有原料时
						if( building.buildingVO.baseVO.type==BuildingType.INDUSTRY){ //弹出Product窗口
							
						}else{ //添加goods，如果没有足够的goods，则显示goods不足提示
							
						}
						break ;
				}
			}
		}
	}
}