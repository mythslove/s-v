package local.views.topbar
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.views.BaseView;
	import local.views.tooltip.GameToolTip;
	
	public class TopBarEnergy extends BaseView
	{
		public var txtValue:TextField ;
		public var bar:Sprite;
		//====================
		
		public function TopBarEnergy()
		{
			super();
		}
		
		override protected function added():void{
			GameToolTip.instance.register(txtValue , stage , "ENERGY:Used to complete tasks." );
		}
		
		public function update(obj:Object):void
		{
			txtValue.text = obj[0]+"/"+obj[1];
			TweenLite.to( bar , 0.2 , {scaleX:  obj[0]/obj[1]});
		}
	}
}