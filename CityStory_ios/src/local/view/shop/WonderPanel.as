package local.view.shop
{
	public class WonderPanel extends ShopPanel
	{
		private static var _instance:WonderPanel;
		public static function get instance():WonderPanel{
			if(!_instance) _instance = new WonderPanel();
			return _instance ;
		}
		//=====================================
		
		public function WonderPanel()
		{
			super();
		}
	}
}