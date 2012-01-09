package views.bottom
{
	import comm.GameData;
	
	import enums.BuildingCurrentOperation;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ToolsMenuAnim extends MovieClip
	{
		public var toolsMenu:ToolsMenu;
		//=========================
		
		public function ToolsMenuAnim()
		{
			super();
			this.mouseEnabled = false ;
			init();
			addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
		}
		
		private function init():void
		{
			this.addFrameScript( 0,addScript,6,addScirpt6);
			function addScript():void{
				visible = false ;
				stop();
			}
			function addScirpt6():void{
				stop();
			}
		}
		
		private function addedToStageHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler ) ;
			stage.addEventListener(MouseEvent.CLICK , stageClickHandler );
			toolsMenu.addEventListener(MouseEvent.CLICK , toolsMenuClickHandler );
		}
		
		private function stageClickHandler(e:MouseEvent):void
		{
			if(this.visible){
				this.gotoAndPlay("hide");
			}
		}
		
		private function toolsMenuClickHandler(e:MouseEvent):void
		{
			switch( e.target )
			{
				case toolsMenu.btnMove :
					GameData.buildingCurrOperation = BuildingCurrentOperation.MOVE ;
					break;
				case toolsMenu.btnSell:
					GameData.buildingCurrOperation = BuildingCurrentOperation.SELL ;
					break ;
				case toolsMenu.btnStash:
					GameData.buildingCurrOperation = BuildingCurrentOperation.STASH ;
					break ;
				case toolsMenu.btnRotate:
					GameData.buildingCurrOperation = BuildingCurrentOperation.ROTATE ;
					break ;
				default :
					GameData.buildingCurrOperation = BuildingCurrentOperation.NONE ;
					break ;
			}
			stageClickHandler(null);
		}
	}
}