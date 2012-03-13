package local.views.topbar
{
	import com.greensock.TweenLite;
	
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
			txtValue.text = obj[0]+"/"+obj[2];
			var pro:int = obj[0]-obj[1];
			TweenLite.to( bar , 0.4 , {scaleX: pro/obj[2]});
			GameToolTip.instance.register(txtValue , stage , "ENERGY:Used to complete tasks.You have "+obj[0] );
		}
	}
}