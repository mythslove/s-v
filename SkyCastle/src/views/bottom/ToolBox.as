package views.bottom
{
	import bing.components.button.BaseButton;
	
	import comm.GameData;
	
	import enums.BuildingCurrentOperation;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
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
			this.addEventListener(MouseEvent.CLICK , onClickHandler );
		}
		private function onClickHandler(e:MouseEvent ):void
		{
			e.stopPropagation();
			switch( e.target )
			{
				case btnMultiTool:
					if( GameData.buildingCurrOperation==BuildingCurrentOperation.NONE){
						toolsMenuAnim.visible = true ;
						toolsMenuAnim.gotoAndPlay(2);
					}else{
						GameData.buildingCurrOperation=BuildingCurrentOperation.NONE ;
						//清空鼠标
					}
					break ;
			}
		}
	}
}