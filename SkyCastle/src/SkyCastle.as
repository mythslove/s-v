package
{
	import comm.GameSetting;
	import comm.GlobalDispatcher;
	import comm.GlobalEvent;
	
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	
	import map.GameWorld;
	
	[SWF( width="760",height="640")]
	public class SkyCastle extends Sprite
	{
		public function SkyCastle()
		{
			super();
			stage.align="TL";
			stage.scaleMode = "noScale";
			stage.quality = StageQuality.MEDIUM;
			stage.addEventListener(Event.RESIZE , onResizeHandler);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN , onResizeHandler);
			
			registerVOs();
			initGame();
		}
		
		private function onResizeHandler(e:Event):void
		{
			e.stopPropagation();
			GameSetting.SCREEN_WIDTH = stage.stageWidth;
			GameSetting.SCREEN_HEIGHT = stage.stageHeight ;
			GlobalDispatcher.instance.dispatchEvent( new GlobalEvent(GlobalEvent.RESIZE));
		}
		
		private function registerVOs():void
		{
			
		}
		
		
		private function initGame():void
		{
			addChild(GameWorld.instance);
		}
	}
}