package local.views.bottom
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import local.comm.GameData;
	import local.enum.BuildingOperation;
	
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
					GameData.buildingCurrOperation = BuildingOperation.MOVE ;
					break;
				case toolsMenu.btnSell:
					GameData.buildingCurrOperation = BuildingOperation.SELL ;
					break ;
				case toolsMenu.btnStash:
					GameData.buildingCurrOperation = BuildingOperation.STASH ;
					break ;
				case toolsMenu.btnRotate:
					GameData.buildingCurrOperation = BuildingOperation.ROTATE ;
					break ;
				default :
					GameData.buildingCurrOperation = BuildingOperation.NONE ;
					break ;
			}
			stageClickHandler(null);
		}
	}
}