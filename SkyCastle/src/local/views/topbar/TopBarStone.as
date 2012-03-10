package local.views.topbar
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.model.village.vos.PlayerVO;
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
		
		public function setPlayer( vo:PlayerVO ):void
		{
			
		}
	}
}