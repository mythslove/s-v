package local.view.shop
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import feathers.controls.Button;
	import feathers.display.Sprite;
	
	import local.comm.GameSetting;
	import local.comm.StyleSetting;
	import local.enum.BuildingType;
	import local.map.GameWorld;
	import local.util.EmbedManager;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.base.GameButton;
	import local.view.shop.panel.*;
	
	import starling.display.Image;
	import starling.events.Event;
	
	public class ShopPopUp extends BaseView
	{
		private static var _instance:ShopPopUp;
		public static function get instance():ShopPopUp{
			if(!_instance) _instance = new ShopPopUp();
			return _instance ;
		}
		//=====================================
		public var isLeft:Boolean ;
		
		public var _container:Sprite ;
		public var btnClose:GameButton ;
		public var btnBack:GameButton ;
		
		private var _wid:Number ;
		private var _het:Number ;
		
		public function ShopPopUp()
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
			btnClose = new GameButton(EmbedManager.getUIImage( StyleSetting.POPUPCLOSEBUTTONUP ));
			btnClose.x = _wid - btnClose.pivotX - 10*GameSetting.GAMESCALE ;
			btnClose.y = 10*GameSetting.GAMESCALE +btnClose.pivotY ;
			addChild(btnClose);
			btnClose.onRelease.add(onClickHandler);
			
			btnBack = new GameButton(EmbedManager.getUIImage( "BackButton" ));
			btnBack.x = btnBack.pivotX+10*GameSetting.GAMESCALE;
			btnBack.y = btnBack.pivotY+10*GameSetting.GAMESCALE;
			addChild( btnBack );
			btnBack.onRelease.add( onClickHandler );
			
			_container = new Sprite();
			_container.x = 40*GameSetting.GAMESCALE;
			_container.y = 120*GameSetting.GAMESCALE ;
			addChild(_container);
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
			TweenLite.from( this , 0.3 , { x:x-temp , ease: Back.easeOut , onComplete:showTweenOver });
		}
		private function showTweenOver():void{
			if(GameSetting.SCREEN_WIDTH<1024) {
				GameWorld.instance.visible=false;
			}
//			if(GameData.isShowTutor && HomePanel.instance.content.numChildren>0 ){
//				(HomePanel.instance.content.getChildAt(0) as ShopItemRenderer).showTutor() ;
//			}
		}
		
		private function onClickHandler( btn:Button ):void
		{
			switch( btn)
			{
				case btnClose:
					close();
					break ;
				case btnBack:
					isLeft = true ;
					close();
					ShopOverViewPopUp.instance.isLeft = true ;
					PopUpManager.instance.addQueuePopUp( ShopOverViewPopUp.instance );
					break ;
			}
		}
		
		/**
		 * 显示 
		 * @param type BuildingType
		 */		
		public function show( type:String ):void
		{
			_container.removeChildren();
			switch( type )
			{
				case BuildingType.HOME:
					_container.addChild(HomePanel.instance) ;
					break ;
				case BuildingType.DECORATION:
					_container.addChild(DecorationPanel.instance) ;
					break ;
				case BuildingType.BUSINESS:
					_container.addChild(BusinessPanel.instance) ;
					break ;
				case BuildingType.INDUSTRY:
					_container.addChild(IndustryPanel.instance) ;
					break ;
//				case BuildingType.COMMUNITY:
//					_container.addChild(CommunityPanel.instance) ;
//					break ;
//				case BuildingType.WONDERS:
//					_container.addChild(WonderPanel.instance) ;
//					break ;
			}
		}
		
		
		private function close():void{
			GameWorld.instance.visible=true;
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
			GameWorld.instance.visible=true;
			isLeft = false ;
		}
	}
}