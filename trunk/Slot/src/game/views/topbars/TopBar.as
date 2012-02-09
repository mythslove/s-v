package game.views.topbars
{
	import bing.components.button.BaseButton;
	import bing.components.button.BaseToggleButton;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import game.comm.GlobalDispatcher;
	import game.comm.GlobalEvent;
	
	public class TopBar extends Sprite
	{
		public var btnBuyCoin:BaseButton;
		public var btnBackToHall:BaseButton;
		public var btnFullScreen:BaseToggleButton;
		public var btnSound:BaseToggleButton;
		public var levelProgress:MovieClip;
		public var txtBalance:TextField ;
		public var txtLevel:TextField;
		//-------------------------------------------------------
		
		public function TopBar()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
		}
		
		private function addedToStageHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			init();
			configListeners();
		}
		
		private function init():void
		{
			levelProgress.stop();
		}
		
		private function configListeners():void
		{
			btnFullScreen.addEventListener(MouseEvent.CLICK , onMouseClickHandler );
		}
		
		private function onMouseClickHandler(e:MouseEvent):void
		{
			switch(e.target)
			{
				case btnFullScreen:
					if(btnFullScreen.selected){
						stage.displayState = StageDisplayState.FULL_SCREEN ;
					}else{
						stage.displayState = StageDisplayState.NORMAL ;
					}
					break ;
			}
		}
	}
}