package local.views.topbar
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.views.BaseView;
	import local.views.tooltip.GameToolTip;
	
	public class TopBarEnergy extends BaseView
	{
		public var txtValue:TextField ;
		public var bar:Sprite;
		//====================
		
		public function TopBarEnergy()
		{
			super();
		}
		
		override protected function added():void
		{
			GameToolTip.instance.register(txtValue , stage , "Your Energy value.");
		}
	}
}