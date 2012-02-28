package local.views.shop.panels
{
	import bing.components.button.BaseButton;
	import bing.components.button.ToggleBar;
	
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
		
		public function ShopBuildingPanel()
		{
			super();
		}
	}
}