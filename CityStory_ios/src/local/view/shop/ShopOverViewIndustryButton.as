package local.view.shop
{
	import flash.display.Bitmap;
	
	import local.view.control.Button;
	import local.view.title.INDUSTRY;

	public class ShopOverViewIndustryButton extends Button
	{
		public function ShopOverViewIndustryButton()
		{
			super();
			var img:Bitmap = new Bitmap( new INDUSTRY(0,0));
			img.x = -img.width>>1 ;
			img.y = 30;
			addChild(img);
		}
	}
}