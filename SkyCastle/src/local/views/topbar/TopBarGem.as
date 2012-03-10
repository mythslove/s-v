package local.views.topbar
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.views.BaseView;
	import local.views.tooltip.GameToolTip;
	
	public class TopBarGem extends BaseView
	{
		public var btnAddGem:SimpleButton;
		public var txtValue:TextField;
		//=========================
		
		public function TopBarGem()
		{
			super();
		}
		
		override protected function added():void
		{
			GameToolTip.instance.register(txtValue , stage , "Your Gem value.");
			GameToolTip.instance.register(btnAddGem , stage , "Click to add Gems.");
		}
	}
}