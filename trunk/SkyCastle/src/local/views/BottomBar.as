package  local.views
{
	import flash.display.Sprite;
	
	import  local.views.bottom.Settings;
	import  local.views.bottom.ToolBox;
	
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