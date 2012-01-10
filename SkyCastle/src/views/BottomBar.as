package views
{
	import flash.display.Sprite;
	
	import views.bottom.Settings;
	import views.bottom.ToolBox;
	
	public class BottomBar extends Sprite
	{
		public var settings:Settings;
		public var toolBox:ToolBox ;
		//============================
		
		public function BottomBar()
		{
			super();
			mouseEnabled=false;
		}
	}
}