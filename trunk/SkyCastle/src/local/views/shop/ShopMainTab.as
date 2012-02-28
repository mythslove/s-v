package local.views.shop
{
	import bing.components.button.BaseToggleButton;
	import bing.components.button.ToggleBar;

	/**
	 * 商店系统的基本tab 
	 * @author zzhanglin
	 */	
	public class ShopMainTab extends ToggleBar
	{
		public var btnBuilding:BaseToggleButton;
		public var btnDecoration:BaseToggleButton;
		public var btnPlant:BaseToggleButton ;
		//====================================
		
		public function ShopMainTab()
		{
			super();
		}
	}
}