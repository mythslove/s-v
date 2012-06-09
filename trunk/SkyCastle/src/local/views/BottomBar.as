package  local.views
{
	import flash.display.Sprite;
	
	import local.views.bottom.Settings;
	import local.views.bottom.ToolBox;
	import local.views.friends.FriendsBar;
	
	public class BottomBar extends Sprite
	{
		public var settings:Settings;
		public var toolBox:ToolBox ;
		public var friendsBar:FriendsBar ; //好友列表
		//============================
		
		public function BottomBar()
		{
			super();
		}
	}
}