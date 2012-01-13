package views.bottom
{
	import bing.components.button.*;
	
	import comm.GlobalDispatcher;
	import comm.GlobalEvent;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import map.GameWorld;
	
	import views.tooltip.GameToolTip;
	
	public class SettingBar extends Sprite
	{
		public var btnDisplay:BaseToggleButton;
		public var btnFullScreen:BaseToggleButton;
		public var btnSound:BaseToggleButton;
		public var btnMusic:BaseToggleButton;
		public var btnZoomIn:BaseButton;
		public var btnZoomOut:BaseButton;
		//=================================
		private var _zoomInTooltip1:String="ZOOM IN: Click to zoom in.";
		private var _zoomInTooltip2:String="ZOOM IN";
		private var _zoomoutTooltip1:String="ZOOM OUT: Click to zoom out.";
		private var _zoomoutTooltip2:String="ZOOM OUT";
		private var _musicTooltip1:String="MUSIC: Click to turn music off.";
		private var _musicTooltip2:String="MUSIC: Click to turn music on.";
		private var _soundTooltip1:String="SOUND EFFECTS: Click to turn sound effects off.";
		private var _soundTooltip2:String="SOUND EFFECTS: Click to turn sound effects on.";
		private var _fullScreenTooltip1:String="FULLSCREEN";
		private var _fullScreenTooltip2:String="EXIT FULLSCREEN";
		
		
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
			GameToolTip.instance.register( btnFullScreen , stage , _fullScreenTooltip1 );
			GameToolTip.instance.register( btnSound , stage , _soundTooltip1 );
			GameToolTip.instance.register( btnMusic , stage , _musicTooltip1 );
			GameToolTip.instance.register( btnZoomIn , stage , _zoomInTooltip2 );
			GameToolTip.instance.register( btnZoomOut , stage , _zoomoutTooltip1 );
			
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
				GameToolTip.instance.register( btnFullScreen , stage , _fullScreenTooltip2 );
			}else{
				stage.displayState = StageDisplayState.NORMAL ;
				GameToolTip.instance.register( btnFullScreen , stage , _fullScreenTooltip1 );
			}
		}
		
		private function onResizeHandler(e:GlobalEvent):void
		{
			if(stage.displayState == StageDisplayState.FULL_SCREEN)
			{
				btnFullScreen.selected = true ;
				GameToolTip.instance.register( btnFullScreen , stage , _fullScreenTooltip2 );
			}else{
				btnFullScreen.selected = false ;
				GameToolTip.instance.register( btnFullScreen , stage , _fullScreenTooltip1 );
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
						GameToolTip.instance.register( btnZoomIn , stage , _zoomInTooltip2 );
						GameToolTip.instance.register( btnZoomOut , stage , _zoomoutTooltip1 );
					}
					break ;
				case btnZoomOut:
					if( GameWorld.instance.scaleX==1 && stage.displayState == StageDisplayState.NORMAL) {
						GameWorld.instance.zoom(0.6);
						GameToolTip.instance.register( btnZoomIn , stage , _zoomInTooltip1 );
						GameToolTip.instance.register( btnZoomOut , stage , _zoomoutTooltip2 );
					}
					break ;
			}
		}
	}
}