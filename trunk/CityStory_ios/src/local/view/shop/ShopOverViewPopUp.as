package local.view.shop
{
	import local.view.base.BaseView;
	
	public class ShopOverViewPopUp extends BaseView
	{
		private static var _instance:ShopOverViewPopUp;
		public static function get instance():ShopOverViewPopUp{
			if(!_instance) _instance = new ShopOverViewPopUp();
			return _instance ;
		}
		//=====================================
		
		public function ShopOverViewPopUp(){
			super();
			
		}
	}
}