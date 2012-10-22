package local.view.products
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class ProductsItemLock extends Sprite
	{
		
		public var txtInfo:TextField ;
		
		public function ProductsItemLock()
		{
			super();
			mouseChildren = mouseEnabled = false ;
		}
	}
}