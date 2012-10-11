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
	import local.map.item.ExpandLandBuilding;
	import local.map.item.Industry;
	import local.util.GameUtil;
	import local.util.PopUpManager;
	import local.view.CenterViewLayer;
	import local.view.base.BuildingThumb;
	import local.view.btn.GrayButton;
	import local.view.btn.GreenButton;
	import local.view.btn.MiniCloseButton;
	import local.view.btn.YellowCashButton;
	import local.view.shop.ShopPopUp;

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
		private var _tweenLite:TweenLite ;
		
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
			if(e.target == btnClose || (!currentBuilding && currentLabel!="nopop" ) )
			{
				this.hide() ;
				return ;
			}
			switch( e.target )
			{
				case btnGreen:
					if(currentLabel=="noroad"){
						GameData.villageMode = VillageMode.EDIT ;
						currentBuilding.onClick();
					}else if(currentLabel=="energy"){
						trace("打开商店Energy窗口");
					}else if(currentLabel=="goods"){
						trace("打开商店Goods窗口");
					}else if( currentLabel=="nopop"){
						GameData.villageMode = VillageMode.NORMAL ;
						//打开商店的房子窗口
						PopUpManager.instance.addQueuePopUp( ShopPopUp.instance , false );
						ShopPopUp.instance.show(BuildingType.HOME);
					}
					this.hide() ;
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
			if(currentBuilding==building){
				return ;
			}
			currentBuilding = building as Building;
			if(!currentBuilding) return ;
			
			if( GameData.villageMode==VillageMode.NORMAL){ 
				// 如果是修建状态
				switch( building.buildingVO.status)
				{
					case BuildingStatus.NO_ROAD: //没路时，显示移动建筑提示 
						this.show() ;
						gotoAndStop("noroad");
						GameUtil.boldTextField( txtInfo , GameUtil.localizationString("gametip.build.noroad.info" ) );
						btnGreen.label =  GameUtil.localizationString("gametip.build.noroad.button" ); 
						break ;
					case BuildingStatus.EXPANDING: //扩地时，显示instant提示
						this.show() ;
						gotoAndStop("expand");
						GameUtil.boldTextField( txtInfo , "expanding ..." );
						btnYellowCash.label = GameUtil.localizationString("gametip.build.product.button" ); 
						break ;
					case BuildingStatus.PRODUCTION: //生产时，显示instant提示
						this.show() ;
						gotoAndStop("product");
						GameUtil.boldTextField( txtTitle , currentBuilding.buildingVO.name );
						switch(currentBuilding.buildingVO.baseVO.type)
						{
							case BuildingType.INDUSTRY:
								GameUtil.boldTextField( txtInfo , GameUtil.localizationString( "gametip.build.product.info",  
									currentBuilding.buildingVO.product.earnGoods , GameUtil.localizationString("goods").toLowerCase()) );
								break ;
							default:
								GameUtil.boldTextField( txtInfo , GameUtil.localizationString( "gametip.build.product.info",  
									currentBuilding.buildingVO.baseVO.earnCoin , GameUtil.localizationString("coins").toLowerCase() ) );
								break ;
						}
						btnYellowCash.label = GameUtil.localizationString("gametip.build.product.button" ); 
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
						GameUtil.boldTextField( txtInfo , GameUtil.localizationString("gametip.goods.expired.info",goods)  );
						btnYellowCash.label = GameUtil.localizationString("gametip.goods.expired.button.saveall");
						btnYellowCash.cash = GameUtil.expiredSaveAllCash(goods)+"";
						btnGray.label =  GameUtil.localizationString("gametip.goods.expired.button.recover" , GameUtil.expiredRecverGoods(goods) ); 
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
		
		/**
		 * 缺少energy 
		 */		
		public function showLackEnergy( building:Building ):void
		{
			if(currentBuilding==building){
				return ;
			}
			currentBuilding = building ;
			show();
			gotoAndStop("energy");
			btnGreen.label = GameUtil.localizationString("gametip.noenergy.button")  ;
			GameUtil.boldTextField( txtInfo , GameUtil.localizationString("gametip.noenergy.info") );
		}
		
		/**
		 * 缺少商品 
		 */		
		public function showLackGoods( building:Building ):void
		{
			if(currentBuilding==building){
				return ;
			}
			currentBuilding = building ;
			show();
			gotoAndStop("goods");
			btnGreen.label = GameUtil.localizationString("gametip.nogoods.button")  ;
			GameUtil.boldTextField( txtInfo , GameUtil.localizationString("gametip.nogoods.info") );
		}
		
		/**
		 * 工厂缺少人口 
		 */		
		public function showLackPop( building:Building ):void
		{
			if(currentBuilding==building){
				return ;
			}
			currentBuilding = building ;
			this.show() ;
			gotoAndStop("nopop");
			GameUtil.boldTextField( txtInfo , "need pop "+GameUtil.buildIndustryPop() );
			btnGreen.label = "GET HOMES"  ;
		}
		
		
		private function show():void
		{
			addEventListener(Event.ENTER_FRAME , updateHandler );
			y= GameSetting.SCREEN_HEIGHT ;
			visible = true ;
			CenterViewLayer.instance.bottomBar.visible = false ;
			if(_tweenLite){
				_tweenLite.kill();
				_tweenLite = null ;
			}
			_tweenLite = TweenLite.to( this , 0.25 , { y :GameSetting.SCREEN_HEIGHT-height+10 , ease:Back.easeOut } );
		}
		
		public function hide():void
		{
			if(visible){
				if(_tweenLite){
					_tweenLite.kill();
					_tweenLite = null ;
				}
				_tweenLite = TweenLite.to( this , 0.2 , { y :GameSetting.SCREEN_HEIGHT , onComplete:function():void{ visible = false ;} } );
				removeEventListener(Event.ENTER_FRAME,updateHandler );
			}
			currentBuilding = null ;
			CenterViewLayer.instance.bottomBar.visible = true ;
		}
		
		private function updateHandler(e:Event):void
		{
			if(currentBuilding)
			{
				if(progressBar){
					if(currentBuilding.gameTimer){
						btnYellowCash.cash = GameUtil.timeToCash( currentBuilding.gameTimer.duration ) +"" ;
						if(currentBuilding.buildingVO.product){
							progressBar.showProgress( currentBuilding.gameTimer , currentBuilding.buildingVO.product.time ) ;
						}else{
							if(currentBuilding is ExpandLandBuilding){
								progressBar.showProgress( currentBuilding.gameTimer , (currentBuilding as ExpandLandBuilding).totalTime ) ;
							}else{
								progressBar.showProgress( currentBuilding.gameTimer , currentBuilding.buildingVO.baseVO.time ) ;
							}
						}
					}else{
						progressBar.progress.x = 0 ;
						GameUtil.boldTextField( progressBar.txtTime , "00:00:00" );
						btnYellowCash.cash = "0";
						currentBuilding = null 
					}
				}
			}
		}
	}
}