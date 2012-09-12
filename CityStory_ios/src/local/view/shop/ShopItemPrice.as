package local.view.shop
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * 价钱标签 
	 * @author zhouzhanglin
	 */	
	public class ShopItemPrice extends MovieClip
	{
		public var txtPrice:TextField ;
		
		public function ShopItemPrice()
		{
			super();
			stop();
			mouseEnabled = mouseChildren = false ;
		}
	}
}