package views.bottom
{
	import bing.components.button.*;
	
	import comm.GlobalDispatcher;
	import comm.GlobalEvent;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Video;
	
	public class SettingBar extends Sprite
	{
		public var btnDisplay:BaseToggleButton;
		public var btnFullScreen:BaseToggleButton;
		public var btnSound:BaseToggleButton;
		public var btnMusic:BaseToggleButton;
		public var btnZoomIn:BaseButton;
		public var btnZoomOut:BaseButton;
		//=================================
		
		public function SettingBar()
		{
			super();
			this.mouseEnabled = false ;
			addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
		}
		
		private function addedToStageHandler ( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			init();
			configListeners();
		}
		
		private function init():void
		{
			onResizeHandler(null);
		}
		
		private function configListeners():void
		{
			GlobalDispatcher.instance.addEventListener(GlobalEvent.RESIZE , onResizeHandler );
			btnFullScreen.addEventListener(MouseEvent.CLICK , fullScreenHandler );
		}
		
		private function fullScreenHandler ( e:MouseEvent ):void
		{
			e.stopPropagation();
			if(btnFullScreen.selected){
				stage.displayState = StageDisplayState.FULL_SCREEN ;
			}else{
				stage.displayState = StageDisplayState.NORMAL ;
			}
		}
		
		private function onResizeHandler(e:GlobalEvent):void
		{
			if(stage.displayState == StageDisplayState.FULL_SCREEN)
			{
				btnFullScreen.selected = true ;
			}else{
				btnFullScreen.selected = false ;
			}
		}
	}
}