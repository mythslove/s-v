package local.views.topbar
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.views.tooltip.GameToolTip;
	
	public class TopBarUserName extends Sprite
	{
		public var txtName:TextField;
		//=====================
		
		public function TopBarUserName()
		{
			super();
			mouseEnabled = mouseChildren = false ;
		}
		
		public function update( obj:Object ):void
		{
			txtName.text = String(obj) ;
		}
	}
}