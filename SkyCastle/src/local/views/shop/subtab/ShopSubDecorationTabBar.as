package local.views.shop.subtab
{
	import bing.components.button.BaseToggleButton;
	import bing.components.button.ToggleBar;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.comm.GameData;

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
		public var txtStone:TextField;
		public var txtTree:TextField;
		public var txtRock:TextField;
		//================================
		public static const BTN_ALL:String = "btnAll";
		public static const BTN_GROUND:String = "btnGround";
		public static const BTN_TREE:String = "btnTree";
		public static const BTN_ROCK:String = "btnRock";
		public static const BTN_STONE:String = "btnStone";
		
		public function ShopSubDecorationTabBar()
		{
			super();
			txtStone.mouseEnabled=txtTree.mouseEnabled = txtRock.mouseEnabled = false ;
			if(!GameData.isAdmin){
				btnTree.visible = btnStone.visible=btnRock.visible=false;
				txtStone.visible=txtTree.visible = txtRock.visible = false ;
			}
		}
	}
}