package local.views.topbar
{
	import flash.text.TextField;
	
	import local.model.village.vos.PlayerVO;
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
		
		public function setPlayer( vo:PlayerVO ):void
		{
			
		}
	}
}