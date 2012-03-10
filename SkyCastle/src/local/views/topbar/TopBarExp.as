package local.views.topbar
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.model.village.vos.PlayerVO;
	import local.views.BaseView;
	import local.views.tooltip.GameToolTip;
	
	public class TopBarExp extends BaseView
	{
		public var txtValue:TextField ;
		public var bar:Sprite;
		//====================
		
		public function TopBarExp()
		{
			super();
		}
		
		override protected function added():void
		{
			GameToolTip.instance.register(txtValue , stage , "Your Experience value." );
		}
		
		public function update(obj:Object):void
		{
			var pro:int = obj[0]-obj[1];
			txtValue.text = obj[0]+"/"+obj[2];
			bar.scaleX = pro/obj[2];
		}
	}
}