package local.views.bottom
{
	import bing.components.button.*;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import local.comm.GlobalDispatcher;
	import local.comm.GlobalEvent;
	import local.game.GameWorld;
	import local.utils.SettingCookieUtil;
	import local.utils.SoundManager;
	import local.views.tooltip.GameToolTip;
	
	public class SettingBar extends Sprite
	{
		public var btnDisplay:BaseToggleButton;
		public var btnFullScreen:BaseToggleButton;
		public var btnSound:BaseToggleButton;
		public var btnMusic:BaseToggleButton;
		public var btnZoomIn:BaseButton;
		public var btnZoomOut:BaseButton;
		//--------------------------------------------------*
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
		//--------------------------------------------------*
		
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
			
			
			SoundManager.instance.soundFlag = SettingCookieUtil.getSound();
			btnMusic.selected = !SoundManager.instance.soundFlag ;
			SoundManager.instance.musicFlag = SettingCookieUtil.getMusic();
			btnMusic.selected = !SoundManager.instance.musicFlag ;
			
			onResizeHandler(null);
		}
		
		private function configListeners():void
		{
			GlobalDispatcher.instance.addEventListener(GlobalEvent.RESIZE , onResizeHandler );
			btnFullScreen.addEventListener(MouseEvent.CLICK , fullScreenHandler );
			btnZoomIn.addEventListener(MouseEvent.CLICK , zoomHandler);
			btnZoomOut.addEventListener(MouseEvent.CLICK , zoomHandler );
			btnMusic.addEventListener(MouseEvent.CLICK , soundHandler );
			btnSound.addEventListener(MouseEvent.CLICK , soundHandler );
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
			var world:GameWorld = GameWorld.instance ;
			switch( e.target)
			{
				case btnZoomIn:
					if( world.scaleX<1) {
						world.zoom(1);
						GameToolTip.instance.register( btnZoomIn , stage , _zoomInTooltip2 );
						GameToolTip.instance.register( btnZoomOut , stage , _zoomoutTooltip1 );
					}
					break ;
				case btnZoomOut:
					if( world.scaleX>0.9 && stage.displayState == StageDisplayState.NORMAL) {
						world.zoom(0.6);
						GameToolTip.instance.register( btnZoomIn , stage , _zoomInTooltip1 );
						GameToolTip.instance.register( btnZoomOut , stage , _zoomoutTooltip2 );
					}
					break ;
			}
		}
		
		private function soundHandler( e:MouseEvent):void
		{
			e.stopPropagation();
			switch( e.target)
			{
				case btnMusic:
					SoundManager.instance.musicFlag = !btnMusic.selected; 
					if(SoundManager.instance.musicFlag){
						SoundManager.instance.playMusicBackground();
					}else{
						SoundManager.instance.stopMusic();
					}
					SettingCookieUtil.saveMusic( SoundManager.instance.musicFlag );
					break ;
				case btnSound:
					SoundManager.instance.soundFlag = !btnSound.selected ; 
					SettingCookieUtil.saveMusic( SoundManager.instance.soundFlag );
					break ;
			}
		}
	}
}