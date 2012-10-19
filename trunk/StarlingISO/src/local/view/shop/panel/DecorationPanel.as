package local.view.shop.panel
{
	import feathers.data.ListCollection;
	
	import local.comm.GameSetting;
	import local.model.ShopModel;
	
	
	public class DecorationPanel extends ShopPanel
	{
		private static var _instance:DecorationPanel;
		public static function get instance():DecorationPanel{
			if(!_instance) _instance = new DecorationPanel();
			return _instance ;
		}
		//=====================================
		
		override protected function init():void
		{
			super.init();
			_list.dataProvider = new ListCollection( ShopModel.instance.baseDecors );
			container.y = -40*GameSetting.GAMESCALE  ;
		}
		
	}
}