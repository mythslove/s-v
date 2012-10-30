package local.view.shop
{
	import flash.display.Bitmap;
	
	import local.view.control.Button;
	import local.view.title.COMMUNITY;

	public class ShopOverViewCommunityButton extends Button
	{
		public function ShopOverViewCommunityButton()
		{
			super();
			var img:Bitmap = new Bitmap( new COMMUNITY(0,0));
			img.x = -img.width>>1 ;
			img.y = 30;
			addChild(img);
		}
	}
}