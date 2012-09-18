package local.view.bottombar
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import local.comm.GameData;
	import local.enum.BuildingStatus;
	import local.enum.BuildingType;
	import local.enum.VillageMode;
	import local.map.item.BaseBuilding;
	import local.map.item.Building;
	import local.view.btn.MiniCloseButton;

	/**
	 * 游戏的tip 
	 * @author zhouzhanglin
	 */	
	public class GameTip extends MovieClip
	{
		public var imgContainer:Sprite ;
		public var btnClose:MiniCloseButton ;
		
		
		
		
		
		
		public var currentBuilding:Building ;
		
		public function GameTip()
		{
			super();
			visible = false ;
			stop();
			imgContainer.mouseChildren = imgContainer.mouseEnabled = false ;
		}
		
		
		public function showBuildingTip( building:BaseBuilding ):void
		{
			return ;
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
					case BuildingStatus.EXPIRED: 
						//过期
						this.show() ;
						
						break ;
				}
			}
		}
		
		private function show():void
		{
			addEventListener(Event.ENTER_FRAME , updateHandler );
			y= 0 ;
			visible = true ;
			TweenLite.to( this , 0.25 , { y :height-50 , ease:Back.easeOut } );
		}
		
		public function hide():void
		{
			TweenLite.to( this , 0.2 , { y :0 , onComplete:function():void{ visible = false ;} } );
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