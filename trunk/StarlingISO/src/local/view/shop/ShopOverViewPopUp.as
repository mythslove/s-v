package local.view.shop
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import feathers.controls.Button;
	
	import local.comm.GameSetting;
	import local.comm.StyleSetting;
	import local.enum.BuildingType;
	import local.map.GameWorld;
	import local.util.EmbedManager;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.base.GameButton;
	
	import starling.display.Image;
	import starling.events.Event;
	
	public class ShopOverViewPopUp extends BaseView
	{
		private static var _instance:ShopOverViewPopUp;
		public static function get instance():ShopOverViewPopUp{
			if(!_instance) _instance = new ShopOverViewPopUp();
			return _instance ;
		}
		//=====================================
		private var _btnClose:GameButton ;
		private var _btnHomes:GameButton ;
		private var _btnIndustry:GameButton ;
		private var _btnBusiness:GameButton ;
		private var _btnDecor:GameButton ;
		private var _btnCommunity:GameButton ;
		private var _btnWonders:GameButton ;
		
		private var _wid:Number ;
		private var _het:Number ;
		
		public function ShopOverViewPopUp()
		{
			super();
			init();
		}
		
		private function init():void
		{
			//背景
			var img:Image = new Image(EmbedManager.createTextureByName(StyleSetting.POPUPBG ));
			addChild( img );
			_wid = img.width ;
			_het = img.height ;
			pivotX = _wid>>1 ;
			pivotY = _het>>1 ;
			//关闭按钮
			img = EmbedManager.getUIImage( StyleSetting.POPUPCLOSEBUTTONUP );
			_btnClose = new GameButton();
			_btnClose.defaultSkin = img ;
			addChild(_btnClose);
			_btnClose.x = _wid - img.width - 10 ;
			_btnClose.y = 10 ;
			_btnClose.onRelease.add(onClickHandler);
			
			
			img = EmbedManager.getUIImage( "ShopOverViewTitle_en" ) ;
			img.x = (_wid - img.width)>>1;
			img.y = 15 ;
			addChild(img);
			
			var btnBgs:Vector.<Image>=new Vector.<Image>(6,true) ;
			var row:int , col:int ;
			for(var i:int = 0 ; i<6 ; ++i)
			{
				img = EmbedManager.getUIImage( "ShopOverViewItemBg" ) ;
				img.x = 80 + (img.width+30)*col ;
				img.y = 150 + (img.height+30)*row ;
				++col;
				if(col==3) {
					col = 0 ;
					++row ;
				}
				btnBgs[i] = img ;
				addChild(img);
			}
			
			var tempW:Number , tempH:Number ;
			img = EmbedManager.getUIImage( "ShopOverViewHomeButton" );
			tempW = img.width;
			tempH = img.height ;
			_btnHomes = new GameButton();
			_btnHomes.x = btnBgs[0].x+(btnBgs[0].width-img.width)*0.5 ;
			_btnHomes.y = btnBgs[0].y+(btnBgs[0].height-img.height)*0.5 ;
			_btnHomes.defaultSkin = img ;
			addChild(_btnHomes);
			img = EmbedManager.getUIImage( "HOMES_en" );
			img.x = (tempW-img.width)*0.5 ;
			img.y = tempH-img.height ;
			img.touchable = false ;
			_btnHomes.addChild( img );
			_btnHomes.onRelease.add(onClickHandler);
			
			
			img = EmbedManager.getUIImage( "ShopOverViewCommunityButton" );
			tempW = img.width;
			tempH = img.height ;
			_btnCommunity = new GameButton();
			_btnCommunity.x = btnBgs[1].x+(btnBgs[1].width-img.width)*0.5 ;
			_btnCommunity.y = btnBgs[1].y+(btnBgs[1].height-img.height)*0.5 ;
			_btnCommunity.defaultSkin = img ;
			addChild(_btnCommunity);
			img = EmbedManager.getUIImage( "COMMUNITY_en" );
			img.x = (tempW-img.width)*0.5 ;
			img.y = tempH-img.height ;
			img.touchable = false ;
			_btnCommunity.addChild( img );
			_btnCommunity.onRelease.add(onClickHandler);
			
			img = EmbedManager.getUIImage( "ShopOverViewDecorButton" );
			tempW = img.width;
			tempH = img.height ;
			_btnDecor = new GameButton();
			_btnDecor.x = btnBgs[2].x+(btnBgs[2].width-img.width)*0.5 ;
			_btnDecor.y = btnBgs[2].y+(btnBgs[2].height-img.height)*0.5 ;
			_btnDecor.defaultSkin = img ;
			addChild(_btnDecor);
			img = EmbedManager.getUIImage( "DECOR_en" );
			img.x = (tempW-img.width)*0.5 ;
			img.y = tempH-img.height ;
			img.touchable = false ;
			_btnDecor.addChild( img );
			_btnDecor.onRelease.add(onClickHandler);
			
			
			img = EmbedManager.getUIImage( "ShopOverViewBusinessButton" );
			tempW = img.width;
			tempH = img.height ;
			_btnBusiness = new GameButton();
			_btnBusiness.x = btnBgs[3].x+(btnBgs[3].width-img.width)*0.5 ;
			_btnBusiness.y = btnBgs[3].y+(btnBgs[3].height-img.height)*0.5 ;
			_btnBusiness.defaultSkin = img ;
			addChild(_btnBusiness);
			img = EmbedManager.getUIImage( "BUSINESS_en" );
			img.x = (tempW-img.width)*0.5 ;
			img.y = tempH-img.height ;
			img.touchable = false ;
			_btnBusiness.addChild( img );
			_btnBusiness.onRelease.add(onClickHandler);
			
			
			img = EmbedManager.getUIImage( "ShopOverViewIndustryButton" );
			tempW = img.width;
			tempH = img.height ;
			_btnIndustry = new GameButton();
			_btnIndustry.x = btnBgs[4].x+(btnBgs[4].width-img.width)*0.5 ;
			_btnIndustry.y = btnBgs[4].y+(btnBgs[4].height-img.height)*0.5 ;
			_btnIndustry.defaultSkin = img ;
			addChild(_btnIndustry);
			img = EmbedManager.getUIImage( "INDUSTRY_en" );
			img.x = (tempW-img.width)*0.5 ;
			img.y = tempH-img.height ;
			img.touchable = false ;
			_btnIndustry.addChild( img );
			_btnIndustry.onRelease.add(onClickHandler);
			
			
			img = EmbedManager.getUIImage( "ShopOverViewWondersButton" );
			tempW = img.width;
			tempH = img.height ;
			_btnWonders = new GameButton();
			_btnWonders.x = btnBgs[5].x+(btnBgs[5].width-img.width)*0.5 ;
			_btnWonders.y = btnBgs[5].y+(btnBgs[5].height-img.height)*0.5 ;
			_btnWonders.defaultSkin = img ;
			addChild(_btnWonders);
			img = EmbedManager.getUIImage( "WONDERS_en" );
			img.x = (tempW-img.width)*0.5 ;
			img.y = tempH-img.height ;
			img.touchable = false ;
			_btnWonders.addChild( img );
			_btnWonders.onRelease.add(onClickHandler);
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			touchable=true;
			GameWorld.instance.stopRun();
			x = GameSetting.SCREEN_WIDTH>>1 ;
			y = GameSetting.SCREEN_HEIGHT>>1 ;
			
			scaleX = scaleY= 0 ;
			alpha = 0 ;
			TweenLite.to( this , 0.3 , { scaleX:1 , scaleY:1 , alpha:1  , ease: Back.easeOut , onComplete:function():void{
				if(!GameSetting.isIpad) GameWorld.instance.visible=false;
			} });
		}
		
		private function onClickHandler( btn:Button ):void
		{
			switch( btn)
			{
				case _btnClose:
					close();
					break ;
				case _btnHomes:
					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance , GameSetting.isIpad );
					ShopPopUp.instance.show(BuildingType.HOME);
					close();
					break ;
//				case _btnDecor:
//					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance , false );
//					ShopPopUp.instance.show(BuildingType.DECORATION);
//					PopUpManager.instance.removeCurrentPopup() ;
//					break ;
//				case _btnBusiness:
//					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance , false );
//					ShopPopUp.instance.show(BuildingType.BUSINESS);
//					PopUpManager.instance.removeCurrentPopup() ;
//					break ;
//				case _btnIndustry:
//					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance , false );
//					ShopPopUp.instance.show(BuildingType.INDUSTRY);
//					PopUpManager.instance.removeCurrentPopup() ;
//					break ;
//				case _btnCommunity:
//					break ;
//				case _btnWonders:
//					break ;
			}
		}
		
		private function close():void{
			touchable=false;
			GameWorld.instance.visible=true;
			TweenLite.to( this , 0.4 , { scaleX:0.3 , scaleY:0 , alpha:0 , ease: Back.easeIn , onComplete:onTweenCom});
		}
		
		private function onTweenCom():void{
			PopUpManager.instance.removeCurrentPopup() ;
		}
		override protected function removedFromStageHandler(e:Event):void{
			super.removedFromStageHandler(e);
			GameWorld.instance.run();
			GameWorld.instance.visible=true;
		}
	}
}