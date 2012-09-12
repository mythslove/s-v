package local.view.shop
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * 价钱标签 
	 * @author zhouzhanglin
	 */	
	public class ShopItemPrice extends MovieClip
	{
		public var txtPrice:Sprite;
		
		public function ShopItemPrice()
		{
			super();
			stop();
			mouseEnabled = mouseChildren = false ;
		}
	}
}