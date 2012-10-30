package local.view.shop
{
	import flash.display.Bitmap;
	
	import local.view.control.Button;
	import local.view.title.BUSINESS;

	public class ShopOverViewBusinessButton extends Button
	{
		public function ShopOverViewBusinessButton()
		{
			super();
			var img:Bitmap = new Bitmap( new BUSINESS(0,0));
			img.x = -img.width>>1 ;
			img.y = 30;
			addChild(img);
		}
	}
}