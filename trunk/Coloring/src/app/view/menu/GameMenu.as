package app.view.menu
{
	import app.comm.Data;
	import app.comm.EditorStatus;
	import app.core.base.BaseView;
	
	import bing.components.events.ToggleItemEvent;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	public class GameMenu extends BaseView
	{
		public var toolMenu:SimpleButton ;
		public var toolBox:ToolBox ;
		//========================
		
		public function GameMenu()
		{
			super();
		}
		
		override protected function addedToStage():void
		{
			toolMenu.addEventListener(MouseEvent.CLICK , onMenuClickHandler );
			toolBox.addEventListener(ToggleItemEvent.ITEM_SELECTED , itemSelectedHandler );
			toolBox.selectedName = toolBox.buchketButton.name ;
		}
		
		private function itemSelectedHandler( e:ToggleItemEvent):void
		{
			switch( e.selectedName )
			{
				case toolBox.brushButton.name:
					Data.editorStatus = EditorStatus.BRUSH ;
					break ;
				case toolBox.buchketButton.name:
					Data.editorStatus = EditorStatus.BUCHKET ;
					break ;
			}
		}
		
		private function onMenuClickHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			if(toolBox.status=="hide"){
				toolBox.show();
			}else{
				toolBox.hide() ;
			}
			this.toolMenu.mouseEnabled = false ;
			setTimeout( ok , 0.5);
		}
		
		private function ok():void
		{
			this.toolMenu.mouseEnabled = true ;
		}
		
		override protected function removedFromStage():void
		{
			toolMenu.removeEventListener(MouseEvent.CLICK , onMenuClickHandler );
			toolBox.removeEventListener(ToggleItemEvent.ITEM_SELECTED , itemSelectedHandler );
		}
	}
}