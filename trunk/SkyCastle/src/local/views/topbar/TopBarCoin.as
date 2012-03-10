package local.views.topbar
{
	import flash.display.SimpleButton;
	import flash.text.TextField;
	
	import local.model.village.vos.PlayerVO;
	import local.views.BaseView;
	import local.views.tooltip.GameToolTip;
	
	public class TopBarCoin extends BaseView
	{
		public var txtValue:TextField ;
		public var btnAddCoin:SimpleButton;
		//=============================
		
		public function TopBarCoin()
		{
			super();
		}
		
		override protected function added():void
		{
			GameToolTip.instance.register(txtValue , stage , "Your Coin value.");
			GameToolTip.instance.register(btnAddCoin , stage , "Click to add Coins.");
		}
		
		public function setPlayer( vo:PlayerVO ):void
		{
			
		}
	}
}