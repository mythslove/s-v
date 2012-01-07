package views
{
	import flash.display.Sprite;

	/**
	 * 视图的容器 
	 * @author zzhanglin
	 */	
	public class CenterViewContainer extends Sprite
	{
		private static var _instance:CenterViewContainer;
		public static function get instance():CenterViewContainer
		{
			if(!_instance) _instance = new CenterViewContainer();
			return _instance; 
		}
		//======================================
		
		public function CenterViewContainer()
		{
			super();
			if(_instance) throw new Error("只能实例化一个");
			else _instance=this ;
			mouseEnabled = false ;
			
			init();
			configListeners();
		}
		
		private function init():void
		{
			showShopBar();
		}
		
		public function showShopBar():void
		{
		}
		
		private function configListeners():void
		{
			
		}
		
	}
}