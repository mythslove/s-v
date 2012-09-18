package local.view.bottombar
{
	import bing.utils.ContainerUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.BuildingStatus;
	import local.enum.BuildingType;
	import local.enum.VillageMode;
	import local.map.item.BaseBuilding;
	import local.map.item.Building;
	import local.map.item.Industry;
	import local.util.GameUtil;
	import local.view.CenterViewLayer;
	import local.view.base.BuildingThumb;
	import local.view.btn.GrayButton;
	import local.view.btn.GreenButton;
	import local.view.btn.MiniCloseButton;
	import local.view.btn.YellowCashButton;

	/**
	 * 游戏的tip 
	 * @author zhouzhanglin
	 */	
	public class GameTip extends MovieClip
	{
		public var imgContainer:Sprite ;
		public var btnClose:MiniCloseButton ;
		public var btnGreen:GreenButton ;
		public var btnYellowCash:YellowCashButton ;
		public var btnGray:GrayButton;
		public var txtInfo:TextField ;
		public var txtTitle:TextField ;
		public var progressBar:GameTipProgressBar ;
		//===================================
		
		
		public var currentBuilding:Building ;
		
		public function GameTip()
		{
			super();
			visible = false ;
			stop();
			imgContainer.mouseChildren = imgContainer.mouseEnabled = false ;
			addEventListener(MouseEvent.CLICK , mouseEvtHandler );
		}
		
		private function mouseEvtHandler( e:MouseEvent ):void
		{
			e.stopPropagation() ;
			switch( e.target )
			{
				case btnClose:
					this.hide() ;
					break ;
				case btnGreen:
					if(currentLabel=="noroad"){
						GameData.villageMode = VillageMode.EDIT ;
						currentBuilding.onClick();
						this.hide() ;
					}
					break ;
				case btnYellowCash:
					if(currentLabel=="product" || currentLabel=="expand"){ //生产中和扩地中
						currentBuilding.instant();
					}else if(currentLabel=="expired"){
						( currentBuilding as Industry).expiredSaveAll() ;
					}
					hide();
					break ;
				case btnGray:
					( currentBuilding as Industry).expiredRecover() ;
					hide();
					break ;
			}
		}
		
		
		public function showBuildingTip( building:BaseBuilding ):void
		{
			currentBuilding = building as Building;
			if( GameData.villageMode==VillageMode.NORMAL){ 
				// 如果是修建状态
				switch( building.buildingVO.status)
				{
					case BuildingStatus.NO_ROAD: //没路时，显示移动建筑提示 
						this.show() ;
						gotoAndStop("noroad");
						GameUtil.boldTextField( txtInfo , "Building must be next to a road in order to be used.");
						btnGreen.label = "Move";
						break ;
					case BuildingStatus.EXPANDING: //扩地时，显示instant提示
						this.show() ;
						break ;
					case BuildingStatus.PRODUCTION: //生产时，显示instant提示
						this.show() ;
						gotoAndStop("product");
						GameUtil.boldTextField( txtTitle , currentBuilding.buildingVO.name );
						switch(currentBuilding.buildingVO.baseVO.type)
						{
							case BuildingType.INDUSTRY:
								GameUtil.boldTextField( txtInfo , "Collect "+currentBuilding.buildingVO.product.earnGoods +" goods in:");
								break ;
							default:
								GameUtil.boldTextField( txtInfo , "Collect "+currentBuilding.buildingVO.baseVO.earnCoin +" coins in:");
								break ;
						}
						btnYellowCash.label = "SPEED UP FOR";
						break ;
					case BuildingStatus.PRODUCTION_COMPLETE:
						this.hide();
						break ;
					case BuildingStatus.LACK_MATERIAL: //没有原料时
						if( building.buildingVO.baseVO.type==BuildingType.BUSINESS){ 
							
							this.show() ;
						}
						break ;
					case BuildingStatus.EXPIRED: 
						//过期
						this.show() ;
						gotoAndStop("expired");
						GameUtil.boldTextField( txtTitle , currentBuilding.buildingVO.name );
						var goods:int = currentBuilding.buildingVO.product.earnGoods ;
						GameUtil.boldTextField( txtInfo , goods+" goods have expired!" );
						btnYellowCash.label = "SAVE ALL FOR";
						btnYellowCash.cash = GameUtil.expiredSaveAllCash(goods)+"";
						btnGray.label = "RECOVER "+GameUtil.expiredRecverGoods(goods) +" GOODS";
						break ;
				}
			}
			
			//图片
			if(imgContainer){
				ContainerUtil.removeChildren( imgContainer );
				var thumb:BuildingThumb = new BuildingThumb( building.buildingVO.name , 120 , 120 );
				imgContainer.addChild( thumb );
				thumb.center() ;
			}
		}
		
		private function show():void
		{
			addEventListener(Event.ENTER_FRAME , updateHandler );
			y= GameSetting.SCREEN_HEIGHT ;
			visible = true ;
			CenterViewLayer.instance.bottomBar.visible = false ;
			TweenLite.to( this , 0.2 , { y :GameSetting.SCREEN_HEIGHT-height+25 , ease:Back.easeOut } );
		}
		
		public function hide():void
		{
			if(visible){
				TweenLite.to( this , 0.1 , { y :GameSetting.SCREEN_HEIGHT , onComplete:function():void{ visible = false ;} } );
				currentBuilding = null ;
				CenterViewLayer.instance.bottomBar.visible = true ;
				removeEventListener(Event.ENTER_FRAME,updateHandler );
			}
		}
		
		private function updateHandler(e:Event):void
		{
			if(currentBuilding && currentBuilding.gameTimer && progressBar)
			{
				btnYellowCash.cash = GameUtil.timeToCash( currentBuilding.gameTimer.duration ) +"" ;
				if(currentBuilding.buildingVO.product){
					progressBar.showProgress( currentBuilding.gameTimer , currentBuilding.buildingVO.product.time ) ;
				}else{
					progressBar.showProgress( currentBuilding.gameTimer , currentBuilding.buildingVO.baseVO.time ) ;
				}
			}
		}
	}
}