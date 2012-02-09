package game.views.topbars
{
	import bing.components.button.BaseButton;
	import bing.components.button.BaseToggleButton;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class TopBar extends Sprite
	{
		public var btnBuyCoin:BaseButton;
		public var btnBackToHall:BaseButton;
		public var btnFullScreen:BaseToggleButton;
		public var txtBalance:TextField ;
		//-------------------------------------------------------
		
		public function TopBar()
		{
			super();
		}
		
	}
}