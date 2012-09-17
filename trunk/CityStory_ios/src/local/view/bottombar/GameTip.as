package local.view.bottombar
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import local.comm.GameData;
	import local.enum.BuildingStatus;
	import local.enum.BuildingType;
	import local.enum.VillageMode;
	import local.map.item.BaseBuilding;
	import local.map.item.Building;

	/**
	 * 游戏的tip 
	 * @author zhouzhanglin
	 */	
	public class GameTip extends MovieClip
	{
		public var currentBuilding:Building ;
		
		public function GameTip()
		{
			super();
			stop();
		}
		
		
		public function showBuildingTip( building:BaseBuilding ):void
		{
			removeEventListener(Event.ENTER_FRAME,updateHandler );
			currentBuilding = building as Building;
			if( GameData.villageMode==VillageMode.NORMAL){ 
				// 如果是修建状态
				switch( building.buildingVO.status)
				{
					case BuildingStatus.NO_ROAD: //没路时，显示移动建筑提示 
						//则显示goods不足提示
						this.show() ;
						break ;
					case BuildingStatus.EXPANDING: //扩地时，显示instant提示
						//则显示goods不足提示
						this.show() ;
						break ;
					case BuildingStatus.PRODUCTION: //生产时，显示instant提示
						//则显示goods不足提示
						this.show() ;
						break ;
					case BuildingStatus.PRODUCTION_COMPLETE:
						
						break ;
					case BuildingStatus.LACK_MATERIAL: //没有原料时
						if( building.buildingVO.baseVO.type==BuildingType.BUSINESS){ 
							//则显示goods不足提示
							this.show() ;
						}
						break ;
				}
			}
		}
		
		private function show():void
		{
			
		}
		
		public function hide():void
		{
			currentBuilding = null ;
			removeEventListener(Event.ENTER_FRAME,updateHandler );
		}
		
		private function updateHandler(e:Event):void
		{
			if(currentBuilding && currentBuilding.gameTimer)
			{
				
			}
		}
	}
}