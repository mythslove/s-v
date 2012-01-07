package views
{
	import flash.display.Sprite;
	/**
	 * 视图的容器 
	 * @author zzhanglin
	 */	
	public class ViewContainer extends Sprite
	{
		private static var _instance:ViewContainer;
		public static function get instance():ViewContainer
		{
			if(!_instance) _instance = new ViewContainer();
			return _instance; 
		}
		//======================================
		
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
		}
		
		private function configListeners():void
		{
			
		}
	}
}