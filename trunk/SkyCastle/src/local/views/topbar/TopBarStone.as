package local.views.topbar
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.views.tooltip.GameToolTip;
	
	public class TopBarStone extends Sprite
	{
		public var txtValue:TextField ;
		//====================
		
		public function TopBarStone()
		{
			super();
		}
		
		public function update(obj:Object):void
		{
			txtValue.text = String(obj) ;	
			GameToolTip.instance.register(txtValue , stage , "STONE: "+obj );
		}
	}
}