package local.view.shop
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import feathers.controls.Button;
	import feathers.display.Sprite;
	
	import local.comm.StyleSetting;
	import local.comm.GameSetting;
	import local.enum.BuildingType;
	import local.map.GameWorld;
	import local.util.EmbedManager;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.base.GameButton;
	import local.view.shop.panel.HomePanel;
	
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
		
		public var _container:Sprite ;
		public var _btnClose:GameButton ;
		
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
			var img:Image = EmbedManager.getUIImage( StyleSetting.POPUPBG ) ;
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
			
			_container = new Sprite();
			_container.x = 40;
			_container.y = 120 ;
			addChild(_container);
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
//				case BuildingType.DECORATION:
//					_container.addChild(DecorationPanel.instance) ;
//					break ;
//				case BuildingType.BUSINESS:
//					_container.addChild(BusinessPanel.instance) ;
//					break ;
//				case BuildingType.INDUSTRY:
//					_container.addChild(IndustryPanel.instance) ;
//					break ;
//				case BuildingType.COMMUNITY:
//					_container.addChild(CommunityPanel.instance) ;
//					break ;
//				case BuildingType.WONDERS:
//					_container.addChild(WonderPanel.instance) ;
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
		}
	}
}