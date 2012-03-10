package local.views.topbar
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.views.tooltip.GameToolTip;
	
	public class TopBarWood extends Sprite
	{
		public var txtValue:TextField ;
		//====================
		
		public function TopBarWood()
		{
			super();
		}
			
		public function update(obj:Object):void
		{
			txtValue.text = String(obj) ;	
			GameToolTip.instance.register(txtValue , stage , "WOOD: "+obj);
		}
	}
}