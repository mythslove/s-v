package local.views.topbar
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class TopBarUserName extends Sprite
	{
		public var txtName:TextField;
		//=====================
		
		public function TopBarUserName()
		{
			super();
		}
		
		public function update( obj:Object ):void
		{
			txtName.text = String(obj) ;
		}
	}
}