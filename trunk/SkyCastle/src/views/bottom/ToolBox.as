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
		public var toolsMenuAnim:ToolsMenuAnim;
		//===============================
		
		public function ToolBox()
		{
			super();
			this.mouseEnabled = false ;
			init();
			configListeners();
		}
		
		private function init():void
		{
			btnReturnHome.visible = false ;
			toolsMenuAnim.visible = false ;
		}
		
		private function configListeners():void
		{
			
		}
	}
}