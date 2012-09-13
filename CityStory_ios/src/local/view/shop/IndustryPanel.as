package local.view.shop
{
	public class IndustryPanel extends ShopPanel
	{
		private static var _instance:IndustryPanel;
		public static function get instance():IndustryPanel{
			if(!_instance) _instance = new IndustryPanel();
			return _instance ;
		}
		//=====================================
		
		public function IndustryPanel()
		{
			super();
		}
	}
}