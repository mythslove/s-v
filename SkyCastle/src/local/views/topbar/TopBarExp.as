package local.views.topbar
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.views.tooltip.GameToolTip;
	
	public class TopBarExp extends Sprite
	{
		public var txtLevel:TextField;
		public var txtValue:TextField ;
		public var bar:Sprite;
		//====================
		
		public function TopBarExp()
		{
			super();
		}
		
		public function update(obj:Object):void
		{
			txtValue.text = obj[0]+"/"+obj[2];
			txtLevel.text = obj[3] ;
			var pro:int = obj[0]-obj[1];
			TweenLite.to( bar , 0.4 , {scaleX: pro/obj[2]});
			GameToolTip.instance.register(txtValue , stage , "EXPERIENCE: "+obj[0]+"/"+obj[2] );
			GameToolTip.instance.register(txtLevel , stage , "LEVEL: "+obj[3] );
		}
	}
}