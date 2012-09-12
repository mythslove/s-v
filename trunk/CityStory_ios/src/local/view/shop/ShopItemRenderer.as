package local.view.shop
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.view.base.MovieClipView;
	import local.vo.BaseBuildingVO;
	
	public class ShopItemRenderer extends MovieClipView
	{
		public var price:ShopItemPrice ;
		public var txtTitle:TextField ;
		public var imgContainer:Sprite;
		public var txtPop:TextField ;
		public var txtCoin:TextField ;
		//===========================
		
		
		public function ShopItemRenderer( baseVO:BaseBuildingVO )
		{
			super();
			mouseChildren = false ;
		}
	}
}