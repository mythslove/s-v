package local.views.topbar
{
	import flash.text.TextField;
	
	import local.views.BaseView;
	import local.views.tooltip.GameToolTip;
	
	public class TopBarWood extends BaseView
	{
		public var txtValue:TextField ;
		//====================
		
		public function TopBarWood()
		{
			super();
		}
		
		override protected function added():void
		{
			GameToolTip.instance.register(txtValue , stage , "Your Wood value.");
		}
		
		public function update(obj:Object):void
		{
			txtValue.text = String(obj) ;	
		}
	}
}