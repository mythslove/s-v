package views
{
	import comm.GameSetting;
	import comm.GlobalDispatcher;
	
	import flash.display.Sprite;
	
	import views.shop.ShopBar;
	
	public class ViewContainer extends Sprite
	{
		private static var _instance:ViewContainer;
		public static function get instance():ViewContainer
		{
			if(!_instance) _instance = new ViewContainer();
			return _instance; 
		}
		//======================================
		private var _shopBar:ShopBar ;
		public function get shopBar():ShopBar{ return _shopBar; }
		
		public function ViewContainer()
		{
			super();
			if(_instance) throw new Error("只能实例化一个");
			else _instance=this ;
			
			init();
			configListeners();
		}
		
		private function init():void
		{
			showShopBar();
		}
		
		public function showShopBar():void
		{
			if(!_shopBar) _shopBar = new ShopBar();
			else if(this.contains(_shopBar)) return ;
			
			_shopBar.x = GameSetting.SCREEN_WIDTH-_shopBar.width ;
			addChild(_shopBar);
		}
		
		private function configListeners():void
		{
			
		}
	}
}