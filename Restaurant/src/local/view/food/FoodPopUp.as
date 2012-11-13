package local.view.food
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.controls.TabBar;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.layout.TiledRowsLayout;
	
	import flash.utils.setTimeout;
	
	import local.comm.GameSetting;
	import local.model.ShopModel;
	import local.util.EmbedManager;
	import local.util.StyleSetting;
	import local.view.CenterViewLayer;
	import local.view.base.BaseView;
	import local.view.base.GameButton;
	import local.view.bottom.BottomBar;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class FoodPopUp extends BaseView
	{
		private static var _instance:FoodPopUp; 
		public static function get instance():FoodPopUp {
			if(!_instance)  _instance= new FoodPopUp();
			return _instance ;
		}
		//--------------------------------------------------------------------
		private var _closeButton:GameButton ;
		private var _bg:Scale9Image ;
		private var _menuBar:TabBar ;
		private var container:Sprite ;
		private var _list:List ;
		private var _layout:TiledRowsLayout ;
		private var _prevBtn:GameButton ;
		private var _nextBtn:GameButton ;
		
		public function FoodPopUp()
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
			_bg.width = 960 ;
			_bg.height = 640;
			addChild( _bg );
			//关闭按钮
			_closeButton = new GameButton( new Scale3Image(StyleSetting.instance.button1Texture));
			_closeButton.defaultSkin.width = 70 ;
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
				[ ]);
			_menuBar.width = _menuBar.maxWidth = this._menuBar.dataProvider.length*(82+8)-8  ;
			//contaner
			container = new Sprite();
			container.x = 100 ;
			container.y = 60;
			addChild(container);
			//listLayout
			_layout = new TiledRowsLayout();
			_layout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			_layout.useSquareTiles = false;
			_layout.gap = 5 ;
			_layout.tileHorizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			_layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
			//list
			_list = new List();
			_list.y = 10 ;
			_list.width = _list.maxWidth = GameSetting.SCREEN_WIDTH-200 ;
			_list.height = 140;
			_list.itemRendererFactory = function():IListItemRenderer { return new ShopItemRender(); };
			_list.layout = _layout;
			_list.scrollerProperties.snapToPages = true;
			_list.scrollerProperties.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_NONE;
			_list.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			container.addChild(_list);
			//page按钮
			_prevBtn = new GameButton(new Scale3Image(StyleSetting.instance.button2Texture));
			_prevBtn.defaultIcon = EmbedManager.getUIImage("PageButton") ;
			_prevBtn.x = -_prevBtn.pivotX*2 ;
			_prevBtn.scaleX = -1 ;
			_prevBtn.y = _list.height>>1 ;
			container.addChild(_prevBtn);
			
			_nextBtn = new GameButton(new Scale3Image(StyleSetting.instance.button2Texture));
			_nextBtn.defaultIcon = EmbedManager.getUIImage("PageButton") ;
			_nextBtn.x = _list.width + _nextBtn.pivotX*2 ;
			_nextBtn.y = _prevBtn.y ;
			container.addChild(_nextBtn);
		}
		
		private function configListeners():void
		{
			_closeButton.addEventListener(Event.TRIGGERED , onCloseHandler );
			_menuBar.addEventListener(Event.CHANGE , menuChangeHandler);
			
			_prevBtn.addEventListener(Event.TRIGGERED , onPageHandler );
			_nextBtn.addEventListener(Event.TRIGGERED , onPageHandler );
			
			_list.addEventListener( "scrollComplete" , listScrollHandler );
			_list.addEventListener("scroll", listScrollHandler );
		}
	}
}