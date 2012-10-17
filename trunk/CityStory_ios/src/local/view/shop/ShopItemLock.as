package local.view.shop
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class ShopItemLock extends Sprite
	{
		public var txtInfo:TextField ;
		
		public function ShopItemLock()
		{
			super();
			mouseChildren = mouseEnabled = false ;
		}
	}
}