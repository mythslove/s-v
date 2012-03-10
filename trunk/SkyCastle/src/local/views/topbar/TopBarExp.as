package local.views.topbar
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.views.BaseView;
	import local.views.tooltip.GameToolTip;
	
	public class TopBarExp extends BaseView
	{
		public var txtValue:TextField ;
		public var bar:Sprite;
		//====================
		
		public function TopBarExp()
		{
			super();
		}
		
		override protected function added():void
		{
			GameToolTip.instance.register(txtValue , stage , "Your Experience value." );
		}
	}
}