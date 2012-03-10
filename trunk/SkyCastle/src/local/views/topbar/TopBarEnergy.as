package local.views.topbar
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.views.tooltip.GameToolTip;
	
	public class TopBarEnergy extends Sprite
	{
		public var txtValue:TextField ;
		public var bar:Sprite;
		//====================
		
		public function TopBarEnergy()
		{
			super();
		}
		
		public function update(obj:Object):void
		{
			txtValue.text = String(obj) ;	
			GameToolTip.instance.register(txtValue , stage , "ENERGY: "+obj);
//			TweenLite.to( bar , 0.4 , {scaleX: pro/obj[2]});
		}
	}
}