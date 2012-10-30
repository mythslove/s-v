package local.view.shop
{
	import flash.display.Bitmap;
	
	import local.view.control.Button;
	import local.view.title.DECOR;

	public class ShopOverViewDecorButton extends Button
	{
		public function ShopOverViewDecorButton()
		{
			super();
			var img:Bitmap = new Bitmap( new DECOR(0,0));
			img.x = -img.width>>1 ;
			img.y = 30;
			addChild(img);
		}
	}
}