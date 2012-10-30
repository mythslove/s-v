package local.view.shop
{
	import flash.display.Bitmap;
	
	import local.view.control.Button;
	import local.view.title.HOMES;

	public class ShopOverViewHomeButton extends Button
	{
		public function ShopOverViewHomeButton()
		{
			super();
			var img:Bitmap = new Bitmap( new HOMES(0,0));
			img.x = -img.width>>1 ;
			img.y = 30;
			addChild(img);
		}
	}
}