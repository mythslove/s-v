package local.view.shop
{
	import flash.display.Bitmap;
	
	import local.view.control.Button;
	import local.view.title.WONDERS;

	public class ShopOverViewWondersButton extends Button
	{
		public function ShopOverViewWondersButton()
		{
			super();
			var img:Bitmap = new Bitmap( new WONDERS(0,0));
			img.x = -img.width>>1 ;
			img.y = 30;
			addChild(img);
		}
	}
}