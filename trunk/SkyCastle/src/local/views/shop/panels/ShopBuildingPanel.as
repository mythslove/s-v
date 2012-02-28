package local.views.shop.panels
{
	import bing.components.button.BaseButton;
	import bing.components.button.ToggleBar;
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
		public var btnPrevButton:BaseButton;
		public var btnNextButton:BaseButton;
		//===================================
		private var _selectedName:String ; 
		
		public function ShopBuildingPanel()
		{
			super();
		}
		
		override protected function added():void
		{
			tabMenu.selectedName = tabMenu.btnAll.name ;
			configListeners();	
		}
		
		private function configListeners():void
		{
			tabMenu.addEventListener( ToggleItemEvent.ITEM_SELECTED , tabMenuHandler , false , 0 , true )
		}
		
		private function tabMenuHandler( e:ToggleItemEvent ):void
		{
			selectedName = e.selectedName ;
		}
		
		public function set selectedName( value :String ):void
		{
			_selectedName = value ;
			switch( name)
			{
				
			}
		}
		
		private function removeListeners():void
		{
			
		}
		override protected function removed():void
		{
			
		}
	}
}