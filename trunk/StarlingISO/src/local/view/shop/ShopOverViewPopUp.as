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
		
		public var isLeft:Boolean ;
		
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
			var img:Image = EmbedManager.getUIImage(StyleSetting.POPUPBG);
			addChild( img );
			_wid = img.width ;
			_het = img.height ;
			pivotX = _wid>>1 ;
			pivotY = _het>>1 ;
			//关闭按钮
			_btnClose = new GameButton(EmbedManager.getUIImage( StyleSetting.POPUPCLOSEBUTTONUP) );
			addChild(_btnClose);
			_btnClose.x = _wid - _btnClose.pivotX - 10*GameSetting.GAMESCALE ;
			_btnClose.y = 10*GameSetting.GAMESCALE +_btnClose.pivotY ;
			_btnClose.onRelease.add(onClickHandler);
			
			
			img = EmbedManager.getUIImage( "ShopOverViewTitle_en" ) ;
			img.x = (_wid - img.width)>>1;
			img.y = 15*GameSetting.GAMESCALE ;
			addChild(img);
			
			var btnBgs:Vector.<Image>=new Vector.<Image>(6,true) ;
			var row:int , col:int ;
			for(var i:int = 0 ; i<6 ; ++i)
			{
				img = EmbedManager.getUIImage( "ShopOverViewItemBg" ) ;
				img.x = 80*GameSetting.GAMESCALE + (img.width+30*GameSetting.GAMESCALE)*col ;
				img.y = 150*GameSetting.GAMESCALE + (img.height+30*GameSetting.GAMESCALE)*row ;
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
			_btnHomes = new GameButton(img);
			_btnHomes.x = btnBgs[0].x+btnBgs[0].width*0.5 ;
			_btnHomes.y = btnBgs[0].y+btnBgs[0].height*0.5 ;
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
			_btnCommunity = new GameButton(img);
			_btnCommunity.x = btnBgs[1].x+btnBgs[1].width*0.5 ;
			_btnCommunity.y = btnBgs[1].y+btnBgs[1].height*0.5 ;
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
			_btnDecor = new GameButton(img);
			_btnDecor.x = btnBgs[2].x+btnBgs[2].width*0.5 ;
			_btnDecor.y = btnBgs[2].y+btnBgs[2].height*0.5 ;
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
			_btnBusiness = new GameButton(img);
			_btnBusiness.x = btnBgs[3].x+btnBgs[3].width*0.5 ;
			_btnBusiness.y = btnBgs[3].y+btnBgs[3].height*0.5 ;
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
			_btnIndustry = new GameButton(img);
			_btnIndustry.x = btnBgs[4].x+btnBgs[4].width*0.5 ;
			_btnIndustry.y = btnBgs[4].y+btnBgs[4].height*0.5 ;
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
			_btnWonders = new GameButton(img);
			_btnWonders.x = btnBgs[5].x+btnBgs[5].width*0.5 ;
			_btnWonders.y = btnBgs[5].y+btnBgs[5].height*0.5 ;
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
			
			var temp:int = 200*GameSetting.GAMESCALE ;
			if(isLeft){
				temp = -200*GameSetting.GAMESCALE ;
			}
			touchable = false ;
			TweenLite.from( this , 0.3 , { x:x-temp , ease: Back.easeOut , onComplete:tweenOver });
		}
		private function tweenOver():void{
			touchable=true;
//			if(GameData.isShowTutor){
//				showTutor();
//			}
		}
		
		private function onClickHandler( btn:Button ):void
		{
			isLeft = false ;
			switch( btn)
			{
				case _btnClose:
					close();
					break ;
				case _btnHomes:
					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance , true );
					ShopPopUp.instance.show(BuildingType.HOME);
					close();
					break ;
				case _btnDecor:
					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance , true );
					ShopPopUp.instance.show(BuildingType.DECORATION);
					close();
					break ;
				case _btnBusiness:
					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance , true );
					ShopPopUp.instance.show(BuildingType.BUSINESS);
					close();
					break ;
				case _btnIndustry:
					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance , true );
					ShopPopUp.instance.show(BuildingType.INDUSTRY);
					close();
					break ;
				case _btnCommunity:
					break ;
				case _btnWonders:
					break ;
			}
		}
		
		private function close():void{
			touchable=false;
			var temp:int = 200*GameSetting.GAMESCALE ;
			if(isLeft){
				temp = -200*GameSetting.GAMESCALE ;
			}
			TweenLite.to( this , 0.3 , { x:x+temp , ease: Back.easeIn , onComplete:onTweenCom});
		}
		
		private function onTweenCom():void{
			PopUpManager.instance.removeCurrentPopup() ;
		}
		override protected function removedFromStageHandler(e:Event):void{
			super.removedFromStageHandler(e);
			GameWorld.instance.run();
			isLeft = false ;
			GameWorld.instance.visible=true;
		}
	}
}