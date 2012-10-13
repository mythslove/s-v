package local.view.shop.panel
{
	
	import com.gskinner.motion.easing.Cubic;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TabBar;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.motion.transitions.TabBarSlideTransitionManager;
	
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
		
		
		private var _navigator:ScreenNavigator;
		private var _tabBar:TabBar;
		private var _transitionManager:TabBarSlideTransitionManager;
		
		public function HomePanel()
		{
			super();
			init();
		}
		
		private function init():void
		{
			this._navigator = new ScreenNavigator();
			_navigator.y = 100 ;
			_navigator.x = 40 ;
			_navigator.width = 800 ;
			this._navigator.onChange.add(navigator_onChange);
			this.addChild(this._navigator);
			
			this._navigator.addScreen(TAB_ALL, new ScreenNavigatorItem(getShopItemLists(TAB_ALL)));
			this._navigator.addScreen(TAB_RESIDENCE, new ScreenNavigatorItem(getShopItemLists(TAB_RESIDENCE)));
			this._navigator.addScreen(TAB_CONDOS, new ScreenNavigatorItem(getShopItemLists(TAB_CONDOS)));
			this._navigator.addScreen(TAB_MANSIONS, new ScreenNavigatorItem(getShopItemLists(TAB_MANSIONS)));
			
			this._tabBar = new TabBar();
			_tabBar.direction = LayoutMode.HORIZONTAL;
			_tabBar.tabInitializer = tabInitializer ;
			_tabBar.gap = 5;
			this._tabBar.onChange.add(tabBar_onChange);
			this.addChild(this._tabBar);
			this._tabBar.dataProvider = new ListCollection(
				[
					{ label: TAB_ALL, action: TAB_ALL },
					{ label: TAB_RESIDENCE, action: TAB_RESIDENCE },
					{ label: TAB_CONDOS, action: TAB_CONDOS },
					{ label: TAB_MANSIONS, action: TAB_MANSIONS }
				]);
			_tabBar.width = _tabBar.maxWidth =_tabBar.dataProvider.data.length*160  ;
				
			this._transitionManager = new TabBarSlideTransitionManager(this._navigator, this._tabBar);
			this._transitionManager.duration = 0.4;
			this._transitionManager.ease = Cubic.easeOut;
		}
		
		override protected function addedToStageHandler(e:Event):void{
			super.addedToStageHandler(e);
			
			this._tabBar.selectedIndex = 0 ;
			this._navigator.showScreen( TAB_ALL );
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
		
		private function getShopItemLists( name:String ):List
		{
			var list:List = new List();
			if(name==TAB_ALL){
				list.dataProvider = new ListCollection( ShopModel.instance.baseHomes );
			}
			list.width = list.maxWidth = 800 ;
			list.itemRendererType = ShopItemRenderer ;
			list.itemRendererFactory = shopItemRenderInitializer;
			const listLayout:HorizontalLayout = new HorizontalLayout();
			listLayout.gap = 10 ;
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			list.layout = listLayout;
			return list ;
		}
		
		private function shopItemRenderInitializer():IListItemRenderer
		{
			var render:ShopItemRenderer = new ShopItemRenderer();
			return render ;
		}
		
		private function navigator_onChange(navigator:ScreenNavigator):void
		{
//			const dataProvider:ListCollection = this._tabBar.dataProvider;
//			const itemCount:int = dataProvider.length;
//			for(var i:int = 0; i < itemCount; i++)
//			{
//				var item:Object = dataProvider.getItemAt(i);
//				if(navigator.activeScreenID == item.action)
//				{
//					this._tabBar.selectedIndex = i;
//					break;
//				}
//			}
		}
		
		private function tabBar_onChange(tabBar:TabBar):void
		{
			if(tabBar.selectedItem){
				this._navigator.showScreen(tabBar.selectedItem.action);
			}
		}
	}
}