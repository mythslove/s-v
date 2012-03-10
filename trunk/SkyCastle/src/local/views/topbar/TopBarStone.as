package local.views.topbar
{
	import flash.text.TextField;
	
	import local.views.BaseView;
	import local.views.tooltip.GameToolTip;
	
	public class TopBarStone extends BaseView
	{
		public var txtValue:TextField ;
		//====================
		
		public function TopBarStone()
		{
			super();
		}

		override protected function added():void
		{
			GameToolTip.instance.register(txtValue , stage , "Your Stone value.");
		}
		
		public function update(obj:Object):void
		{
			txtValue.text = String(obj) ;	
		}
	}
}