package local.view.shop.panel
{
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.controls.TabBar;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	
	import flash.text.TextFormat;
	
	import local.comm.StyleSetting;
	import local.model.ShopModel;
	import local.view.shop.ShopItemRenderer;
	
	import org.osmf.layout.LayoutMode;
	
	import starling.events.Event;
	
	public class HomePanel extends ShopPanel
	{
		private static var _instance:HomePanel;
		public static function get instance():HomePanel{
			if(!_instance) _instance = new HomePanel();
			return _instance ;
		}
		//=====================================
		public static const TAB_ALL:String = "ALL";
		public static const  TAB_RESIDENCE:String = "RESIDENCE";
		public static const  TAB_CONDOS:String = "CONDOS";
		public static const  TAB_MANSIONS:String = "MANSIONS";
		
		
		private var _tabBar:TabBar;
		private var _layout:TiledRowsLayout ;
		private var _list:List ;
		
		public function HomePanel()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_layout = new TiledRowsLayout();
			_layout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			_layout.useSquareTiles = false;
			_layout.tileHorizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			_layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			
			this._tabBar = new TabBar();
			_tabBar.direction = LayoutMode.HORIZONTAL;
			_tabBar.tabInitializer = tabInitializer ;
			_tabBar.gap = 5;
			this._tabBar.onChange.add(tabBar_onChange);
			this.addChild(this._tabBar);
			this._tabBar.dataProvider = new ListCollection(
				[
					{ label: TAB_ALL }, { label: TAB_RESIDENCE }, { label: TAB_CONDOS }, { label: TAB_MANSIONS }
				]);
			_tabBar.width = _tabBar.maxWidth =_tabBar.dataProvider.data.length*160  ;
			
			_list = new List();
			_list.width = _list.maxWidth = 800 ;
			_list.height = 340;
			_list.itemRendererFactory = function():IListItemRenderer {
				return new ShopItemRenderer();
			};
			_list.layout = _layout;
			_list.y = 80 ;
			_list.x = 40 ;
			_list.scrollerProperties.snapToPages = true;
			_list.scrollerProperties.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_NONE;
			_list.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			addChild(_list);
			
		}
		
		
		override protected function addedToStageHandler(e:Event):void{
			super.addedToStageHandler(e);
			
			this._tabBar.selectedIndex = 0 ;
			tabBar_onChange( _tabBar );
		}
		
		private function tabInitializer(tab:Button , item:Object ):void
		{
			tab.defaultSkin = StyleSetting.TAB_UP_SKIN() ;
			tab.downSkin =  StyleSetting.TAB_DOWN_SKIN() ;
			tab.selectedUpSkin = StyleSetting.TAB_SELECTED_BUTTON() ;
			tab.label = item.label ;
			tab.defaultLabelProperties.textFormat = new TextFormat("Verdana",20,0xffffff,true);
			tab.paddingLeft = tab.paddingRight = 4;
		}
		
		private function tabBar_onChange(tabBar:TabBar):void
		{
			if(tabBar.selectedItem){
				switch(tabBar.selectedItem.label)
				{
					case TAB_ALL:
						_list.dataProvider = new ListCollection( ShopModel.instance.baseHomes );
						break ;
					default:
						_list.dataProvider = null ;
						break ;
				}
			}
		}
	}
}