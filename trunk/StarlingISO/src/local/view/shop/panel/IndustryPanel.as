package local.view.shop.panel
{
	import feathers.data.ListCollection;
	
	import local.model.ShopModel;
	
	public class IndustryPanel extends ShopPanel
	{
		private static var _instance:IndustryPanel;
		public static function get instance():IndustryPanel{
			if(!_instance) _instance = new IndustryPanel();
			return _instance ;
		}
		//=====================================
		
		override protected function init():void
		{
			super.init();
			_list.dataProvider = new ListCollection( ShopModel.instance.baseIndustry );
			container.y = -40 ;
		}
		
	}
}