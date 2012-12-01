package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import game.StarlingAppliaction;
	import game.comm.GameSetting;
	
	import starling.core.Starling;
	
	public class Racing extends Sprite
	{
		private var _starling:Starling ;
		
		public function Racing()
		{
			super();
			
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60 ;
			init();
		}
		
		private function init():void
		{
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = true; // not necessary on iOS. Saves a lot of memory!
			
			_starling = new Starling( StarlingAppliaction, stage , new Rectangle(0,0,stage.fullScreenWidth,stage.fullScreenHeight) ,null , "auto", "baseline" );
			_starling.showStats = true ;
			_starling.antiAliasing = 0 ;
			_starling.enableErrorChecking = false ;
			
			if(stage.fullScreenWidth%1024==0){
				//ipad3
				GameSetting.SCREEN_WIDTH = _starling.stage.stageWidth = 1024;
				GameSetting.SCREEN_HEIGHT =_starling.stage.stageHeight  = 768 ;
			}
			else if( stage.fullScreenWidth%480==0)
			{
				GameSetting.SCREEN_WIDTH = _starling.stage.stageWidth = 960;
				GameSetting.SCREEN_HEIGHT = _starling.stage.stageHeight  = 640 ;
			}
			_starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE , contextCreatedHandler );
		}
		
		private function contextCreatedHandler( e:Event):void
		{
			_starling.stage3D.removeEventListener(Event.CONTEXT3D_CREATE , contextCreatedHandler );
			_starling.start() ;
		}
	}
}