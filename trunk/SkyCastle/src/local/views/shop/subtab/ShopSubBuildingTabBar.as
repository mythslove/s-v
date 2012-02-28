package local.views.shop.subtab
{
	import bing.components.button.BaseToggleButton;
	import bing.components.button.ToggleBar;
	/**
	 * 商店建筑面板上面的tab 
	 * @author zzhanglin
	 */	
	public class ShopSubBuildingTabBar extends ToggleBar
	{
		public var btnAll:BaseToggleButton ;
		public var btnHouse:BaseToggleButton;
		public var btnFactory:BaseToggleButton;
		//================================
		public static const BTN_ALL:String = "btnAll";
		public static const BTN_HOUSE:String = "btnHouse";
		public static const BTN_FACTOR:String = "btnFactory";
		
		public function ShopSubBuildingTabBar()
		{
			super();
		}
	}
}