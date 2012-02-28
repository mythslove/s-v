package local.views.shop.panels
{
	import bing.components.button.BaseButton;
	import bing.components.events.ToggleItemEvent;
	
	import flash.display.Sprite;
	
	import local.views.BaseView;

	/**
	 * 商店中的建筑面板
	 * @author zzhanglin
	 */	
	public class ShopBuildingPanel extends BaseView
	{
		public var tabMenu:ShopSubBuildingTabBar ;
		public var container:Sprite;
		public var btnPrevPage:BaseButton;
		public var btnNextPage:BaseButton;
		//===================================
		
		public function ShopBuildingPanel()
		{
			super();
		}
		
		override protected function added():void
		{
			tabMenu.addEventListener( ToggleItemEvent.ITEM_SELECTED , tabMenuHandler , false , 0 , true ) ;
			tabMenu.selectedName = tabMenu.btnAll.name ;
		}
		
		private function tabMenuHandler( e:ToggleItemEvent ):void 
		{
			switch( e.selectedName)
			{
				
			}
		}
		
		override protected function removed():void
		{
			tabMenu.removeEventListener( ToggleItemEvent.ITEM_SELECTED , tabMenuHandler );
		}
	}
}