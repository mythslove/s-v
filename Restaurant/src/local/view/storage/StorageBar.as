package local.view.storage
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
	import local.model.StorageModel;
	import local.util.EmbedManager;
	import local.util.StyleSetting;
	import local.view.CenterViewLayer;
	import local.view.base.BaseView;
	import local.view.base.GameButton;
	import local.view.bottom.BottomBar;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class StorageBar extends BaseView
	{
		private static var _instance:StorageBar; 
		public static function get instance():StorageBar {
			if(!_instance)  _instance= new StorageBar();
			return _instance ;
		}
		//--------------------------------------------------------------------
		public const TAB_WALL_PAPER:String = "WPAPER";
		public const TAB_WALL_DECO:String = "WDECO";
		public const TAB_TABLE:String = "TABLE";
		public const TAB_FLOOR:String = "FLOOR";
		public const TAB_CHAIR:String = "CHAIR";
		public const TAB_DECOR:String = "DECOR";
		public const TAB_STOVE:String = "STOVE";
		public const TAB_COUNTER:String = "COUNTER";
		
		private var _closeButton:GameButton ;
		private var _bg:Scale9Image ;
		private var _menuBar:TabBar ;
		private var container:Sprite ;
		private var _list:List ;
		private var _layout:TiledRowsLayout ;
		private var _prevBtn:GameButton ;
		private var _nextBtn:GameButton ;
		
		public function StorageBar()
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
			_closeButton.defaultSkin.width = 80 ;
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
			_layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			//list
			_list = new List();
			_list.width = _list.maxWidth = GameSetting.SCREEN_WIDTH-200 ;
			_list.height = 140;
			_list.itemRendererFactory = function():IListItemRenderer { return new StorageItemRender(); };
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
		
		private function menuChangeHandler( e:Event ):void{
			if(_menuBar.selectedItem){
				switch(_menuBar.selectedItem)
				{
					case TAB_WALL_PAPER:
						_list.dataProvider = new ListCollection(StorageModel.instance.wallPapers);
						break ;
					case TAB_WALL_DECO:
						_list.dataProvider = new ListCollection(StorageModel.instance.wallDecors);
						break ;
					case TAB_TABLE:
						_list.dataProvider = new ListCollection(StorageModel.instance.tables);
						break ;
					case TAB_FLOOR:
						_list.dataProvider = new ListCollection(StorageModel.instance.floors);
						break ;
					case TAB_CHAIR:
						_list.dataProvider = new ListCollection(StorageModel.instance.chairs);
						break ;
					case TAB_DECOR:
						_list.dataProvider = new ListCollection(StorageModel.instance.decors);
						break ;
					case TAB_STOVE:
						_list.dataProvider = new ListCollection(StorageModel.instance.stoves);
						break ;
					case TAB_COUNTER:
						_list.dataProvider = new ListCollection(StorageModel.instance.counters);
						break ;
				}
			}
		}
		
		
		private function onPageHandler( e:Event ):void
		{
			var page:int = _list.horizontalScrollPosition / _list.maxHorizontalScrollPosition ;
			if(e.target== _prevBtn){
				_list.scrollToDisplayIndex( (page-1)*3 , 0.3 );
			}else{
				_list.scrollToDisplayIndex( (page+1)*3 , 0.3 );
			}
		}
		
		private function listScrollHandler( e:Event ):void
		{
			switch(e.type)
			{
				case "scroll":
					if( _nextBtn.visible || _prevBtn.visible){
						_nextBtn.visible = _prevBtn.visible = false ;
					}
					break ;
				case "scrollComplete":
					var maxPage:int = _list.maxHorizontalScrollPosition / _list.maxWidth ;
					var page:int = _list.horizontalScrollPosition / _list.maxHorizontalScrollPosition ;
					if(maxPage==0){
						_nextBtn.visible = _prevBtn.visible = false ;
					}else if(page==0){
						_prevBtn.visible = false ;
						_nextBtn.visible = true ;
					}else if(page==maxPage){
						_prevBtn.visible = true ;
						_nextBtn.visible = false ;
					}else{
						_nextBtn.visible = _prevBtn.visible = true ;
					}
					break ;
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		//=======================================================
		
		private function onCloseHandler( e:Event ):void{ 
			close();
			setTimeout(function():void{
				var bottomBar:BottomBar = CenterViewLayer.instance.bottomBar;
				bottomBar.btnStorage.visible=bottomBar.btnDone.visible = true ;
			},200);
		}
		private function close():void
		{
			touchable = false ;
			TweenLite.to( this , 0.2 , { y:0 , onComplete:tweenOver} ) ;
		}
		private function tweenOver():void{
			if(parent) parent.removeChild(this);
		}
		override protected function addedToStageHandler(e:Event):void {
			super.addedToStageHandler(e);
			x = ( GameSetting.SCREEN_WIDTH-width)>>1 ;
			y=0;
			TweenLite.to( this , 0.2 , { y:-250 , onComplete: function():void{ 
				touchable = true ;
			} ,ease:Sine.easeOut  });
		}
	}
}