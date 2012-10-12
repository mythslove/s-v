package local.view
{
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.shop.ShopOverViewPopUp;
	
	import starling.events.Event;
	
	public class UILayer extends BaseView
	{
		private static var _instance:UILayer; 
		public static function get instance():UILayer
		{
			if(!_instance)  _instance= new UILayer();
			return _instance ;
		}
		//-----------------------------------------------------------
		
		public function UILayer()
		{
			
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			PopUpManager.instance.addQueuePopUp( new ShopOverViewPopUp());
		}
	}
}