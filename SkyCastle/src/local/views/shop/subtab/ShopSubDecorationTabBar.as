package local.views.shop.subtab
{
	import bing.components.button.BaseToggleButton;
	import bing.components.button.ToggleBar;
	
	import flash.display.Sprite;

	/**
	 *  装饰面板TabBar 
	 * @author zzhanglin
	 */	
	public class ShopSubDecorationTabBar extends ToggleBar
	{
		public var btnAll:BaseToggleButton ;
		public var btnGround:BaseToggleButton;
		public var btnTree:BaseToggleButton;
		public var btnStone:BaseToggleButton;
		public var btnRock:BaseToggleButton;
		public var mcMask:Sprite ;
		//================================
		public static const BTN_ALL:String = "btnAll";
		public static const BTN_GROUND:String = "btnGround";
		public static const BTN_TREE:String = "btnTree";
		public static const BTN_ROCK:String = "btnRock";
		public static const BTN_STONE:String = "btnStone";
		
		public function ShopSubDecorationTabBar()
		{
			super();
		}
	}
}