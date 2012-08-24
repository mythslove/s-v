package local.views.topbar
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.model.vos.PlayerVO;
	import local.views.base.BaseView;
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
			GameToolTip.instance.register(btnAddGem , stage , "Click to add gems.");
			GameToolTip.instance.register(txtValue , stage , "GEM: Purchase items and energy with gems.");
		}
		
		public function update(obj:Object):void
		{
			txtValue.text = String(obj) ;	
		}
	}
}