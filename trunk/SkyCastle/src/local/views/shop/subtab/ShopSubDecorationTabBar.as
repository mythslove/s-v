package local.views.shop.subtab
{
	import bing.components.button.BaseToggleButton;
	import bing.components.button.ToggleBar;
	/**
	 *  装饰面板TabBar 
	 * @author zzhanglin
	 */	
	public class ShopSubDecorationTabBar extends ToggleBar
	{
		public var btnAll:BaseToggleButton ;
		public var btnGround:BaseToggleButton;
		//================================
		public static const BTN_ALL:String = "btnAll";
		public static const BTN_GROUND:String = "btnGround";
		
		public function ShopSubDecorationTabBar()
		{
			super();
		}
	}
}