package local.views.topbar
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.views.base.BaseView;
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
			GameToolTip.instance.register(txtValue , stage , "STONE: Used to build buildings,Get stone by clear stones and ruins." );
		}
		
		public function update(obj:Object):void
		{
			txtValue.text = String(obj) ;	
		}
	}
}