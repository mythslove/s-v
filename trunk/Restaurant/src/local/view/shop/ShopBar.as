package local.view.shop
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	
	import local.comm.GameSetting;
	import local.util.EmbedManager;
	import local.util.StyleSetting;
	import local.view.base.BaseView;
	import local.view.base.GameButton;
	
	import starling.events.Event;
	
	public class ShopBar extends BaseView
	{
		private static var _instance:ShopBar; 
		public static function get instance():ShopBar {
			if(!_instance)  _instance= new ShopBar();
			return _instance ;
		}
		//--------------------------------------------------------------------
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
		
		public function ShopBar()
		{
			super();
			init();
			configListeners();
		}
		private function init():void
		{
			//背景
			_bg = new Scale9Image(StyleSetting.instance.popup1Texture );
			_bg.touchable = false ;
			_bg.width = GameSetting.SCREEN_WIDTH ;
			_bg.height = 250 ;
			addChild( _bg );
			//关闭按钮
			_closeButton = new GameButton( new Scale3Image(StyleSetting.instance.button1Texture));
			_closeButton.defaultIcon = EmbedManager.getUIImage("WhiteRight")
			_closeButton.x = _bg.width - _closeButton.defaultSkin.width*0.5-10;
			_closeButton.y = -_closeButton.pivotY ;
			addChild(_closeButton);
			//tabBar
			_menuBar = new TabBar();
			_menuBar.direction = TabBar.DIRECTION_HORIZONTAL;
			_menuBar.tabInitializer = StyleSetting.instance.tabInitializer  ;
			_menuBar.gap = 8 ;
			_menuBar.y = -30;
			_menuBar.x = 40 ;
			this.addChild(_menuBar);
			this._menuBar.dataProvider = new ListCollection(
				[
					TAB_WALL_PAPER,TAB_WALL_DECO ,TAB_TABLE,TAB_FLOOR,TAB_CHAIR
					,TAB_DECOR,TAB_STOVE,TAB_COUNTER
				]);
			_menuBar.width = _menuBar.maxWidth = this._menuBar.dataProvider.length*(82+8)-8  ;
		}
		
		private function configListeners():void
		{
			_closeButton.addEventListener(Event.TRIGGERED , onCloseHandler );
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		//=======================================================
		private function onCloseHandler( e:Event ):void{ close(); }
		private function close():void
		{
			touchable = false ;
			TweenLite.to( this , 0.2 , { y:0 , onComplete:tweenOver} ) ;
		}
		private function tweenOver():void{
			if(parent) parent.removeChild(this);
//			GameData.villageMode = VillageMode.EDIT ;
		}
		override protected function addedToStageHandler(e:Event):void {
			super.addedToStageHandler(e);
			x = ( GameSetting.SCREEN_WIDTH-width)>>1 ;
			y=0;
			TweenLite.to( this , 0.2 , { y:-250 , onComplete: function():void{ 
				touchable = true ;
			} ,ease:Sine.easeOut  });
			
//			tabBar_onChange(menuBar);
		}
	}
}