package local.view.shop
{
	public class CommunityPanel extends ShopPanel
	{
		private static var _instance:CommunityPanel;
		public static function get instance():CommunityPanel{
			if(!_instance) _instance = new CommunityPanel();
			return _instance ;
		}
		//=====================================
		
		public function CommunityPanel()
		{
			super();
			container.y =30 ; 
		}
	}
}