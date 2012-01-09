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
	
	import map.GameWorld;
	
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
			btnZoomIn.addEventListener(MouseEvent.CLICK , zoomHandler);
			btnZoomOut.addEventListener(MouseEvent.CLICK , zoomHandler );
		}
		
		private function fullScreenHandler ( e:MouseEvent ):void
		{
			e.stopPropagation();
			if(btnFullScreen.selected){
				stage.displayState = StageDisplayState.FULL_SCREEN ;
				GameWorld.instance.zoom(1);
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
		
		private function zoomHandler(e:MouseEvent):void
		{
			e.stopPropagation();
			switch( e.target)
			{
				case btnZoomIn:
					if( GameWorld.instance.scaleX<1) {
						GameWorld.instance.zoom(1);
					}
					break ;
				case btnZoomOut:
					if( GameWorld.instance.scaleX==1 && stage.displayState == StageDisplayState.NORMAL) {
						GameWorld.instance.zoom(0.6);
					}
					break ;
			}
		}
	}
}