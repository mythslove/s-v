package local.view.shop
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	
	import local.comm.GameSetting;
	import local.util.EmbedManager;
	import local.util.PopUpManager;
	import local.util.StyleSetting;
	import local.view.CenterViewLayer;
	import local.view.base.BaseView;
	import local.view.base.GameButton;
	
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class ShopPopUp extends BaseView
	{
		private static var _instance:ShopPopUp; 
		public static function get instance():ShopPopUp {
			if(!_instance)  _instance= new ShopPopUp();
			return _instance ;
		}
		//-----------------------------------------------------------
		public static const TAB_WALL_PAPER:String = "WPAPER";
		public static const  TAB_WALL_DECO:String = "WDECO";
		public static const  TAB_TABLE:String = "TABLE";
		public static const  TAB_FLOOR:String = "FLOOR";
		public static const TAB_CHAIR:String = "CHAIR";
		public static const  TAB_DECOR:String = "DECOR";
		public static const  TAB_STOVE:String = "STOVE";
		public static const  TAB_COUNTER:String = "COUNTER";
		
		private var _closeButton:GameButton ;
		private var _bg:Scale9Image ;
		private var _menuBar:TabBar ;
		
		public function ShopPopUp()
		{
			super();
			pivotX = 960 >> 1 ;
			pivotY = 640 >> 1 ;
			init();
			configListeners();
		}
		private function init():void
		{
			//背景
			_bg = new Scale9Image(StyleSetting.instance.popup1Texture );
			_bg.touchable = false ;
			_bg.width = 960 ;
			_bg.height = 640 ;
			addChild( _bg );
			//关闭按钮
			_closeButton = new GameButton(EmbedManager.getUIImage("PopUpCloseButton"));
			_closeButton.x = _bg.width - _closeButton.defaultSkin.width*0.5-10;
			_closeButton.y =  _closeButton.defaultSkin.height*0.5 + 10;
			addChild(_closeButton);
			//标题
			var title:TextField = new TextField(300 , 70,"MARKET","TitleFont",70, 0x330000 ,false);
			title.touchable = false ;
			title.x = 6+_bg.width>>1 ;
			title.y = 26 ;
			title.hAlign = HAlign.CENTER ;
			title.pivotX = title.width>> 1 ;
			addChild( title );
			title = new TextField(300 , 70,"MARKET","TitleFont",70, 0xff9900 ,false);
			title.touchable = false ;
			title.x = _bg.width>>1 ;
			title.y = 20 ;
			title.hAlign = HAlign.CENTER ;
			title.pivotX = title.width>> 1 ;
			addChild( title );
			//tabBar
			_menuBar = new TabBar();
			_menuBar.direction = TabBar.DIRECTION_HORIZONTAL;
			_menuBar.tabInitializer = StyleSetting.instance.tabInitializer  ;
			_menuBar.gap = 8 ;
			_menuBar.y = 110;
			_menuBar.x = 40;
			this.addChild(_menuBar);
			this._menuBar.dataProvider = new ListCollection(
				[
					TAB_WALL_PAPER,TAB_WALL_DECO ,TAB_TABLE,TAB_FLOOR,TAB_CHAIR
					,TAB_DECOR,TAB_STOVE,TAB_COUNTER
				]);
			_menuBar.width = _menuBar.maxWidth = _bg.width-80  ;
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			CenterViewLayer.instance.visible = false ;
			
			scaleX = scaleY = 0 ;
			TweenLite.to( this , 0.3 , {  scaleX:1 , scaleY:1 , ease: Back.easeOut });
		}
		
		private function configListeners():void
		{
			_closeButton.addEventListener(Event.TRIGGERED , onCloseHandler );
		}
		
		
		
		
		
		
		private function onCloseHandler( e:Event ):void{
			close();
		}
		private function close():void
		{
			touchable = false ;
			TweenLite.to( this , 0.3 , {  scaleX:0 , scaleY:0 , ease: Back.easeIn , onComplete:onCloseTweenOver });
		}
		private function onCloseTweenOver():void
		{
			touchable = true ;
			CenterViewLayer.instance.visible = true ;
			PopUpManager.instance.removeCurrentPopup() ;
		}
	}
}