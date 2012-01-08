package views.bottom
{
	import bing.components.button.BaseButton;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ToolBox extends Sprite
	{
		public var btnMultiTool:BaseButton ;
		public var btnCancelTool:BaseButton;
		public var btnShopTool:BaseButton;
		public var btnBagTool:BaseButton ;
		public var btnReturnHome:BaseButton;
		//===============================
		
		public function ToolBox()
		{
			super();
			init();
			configListeners();
		}
		
		private function init():void
		{
			btnReturnHome.visible = false ;
		}
		
		private function configListeners():void
		{
			
		}
	}
}