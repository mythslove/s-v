package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import local.GameSetting;
	import local.MainGame;
	
	import starling.core.Starling;
	
	[SWF(frameRate="60",backgroundColor=0)]
	public class StarlingISO extends Sprite
	{
		private var _starling:Starling ;
		
		public function StarlingISO()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			if (Capabilities.screenResolutionY <=960)
			{
				if(Capabilities.screenResolutionY<960){
					this.scaleX = 0.5;
					this.scaleY = 0.5;
				}
				GameSetting.SCREEN_WIDTH = 960;
				GameSetting.SCREEN_HEIGHT = 640;
			}
			else 
			{
				GameSetting.SCREEN_WIDTH = 1024;
				GameSetting.SCREEN_HEIGHT = 768;
			}
			
			
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = true; // not necessary on iOS. Saves a lot of memory!
			
			_starling = new Starling( MainGame , stage , new Rectangle(0,0,GameSetting.SCREEN_WIDTH,GameSetting.SCREEN_HEIGHT)
				,  null, "auto", "baseline" );
			_starling.showStats = true ;
			_starling.antiAliasing = 0 ;
			_starling.enableErrorChecking = false ;
			_starling.start();
		}
	}
}