package
{
	import flash.geom.Rectangle;
	
	import local.MainGame;
	import local.comm.GameSetting;
	
	import starling.core.Starling;
	
	public class StarlingISO extends BaseVillage
	{
		private var _starling:Starling ;
		
		public function StarlingISO()
		{
			super();
		}
		
		override protected function initGame():void
		{
			super.initGame();
			
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = true; // not necessary on iOS. Saves a lot of memory!
			
			_starling = new Starling( MainGame , stage , new Rectangle(0,0,stage.fullScreenWidth,stage.fullScreenHeight) ,  null, "auto", "baseline" );
			_starling.showStats = true ;
			_starling.antiAliasing = 0 ;
			_starling.enableErrorChecking = false ;
			
			if(stage.fullScreenWidth >= 1024){
				//ipad1,2,3
				GameSetting.isIpad = true ;
				GameSetting.SCREEN_HEIGHT =_starling.stage.stageHeight  = 768 ;
				GameSetting.SCREEN_WIDTH = _starling.stage.stageWidth = 1024;
			}else if( stage.stage.fullScreenHeight >= 1136){
				//iphone5
				GameSetting.isIpad = false ;
				GameSetting.SCREEN_HEIGHT =_starling.stage.stageHeight  = 640 ;
				GameSetting.SCREEN_WIDTH = _starling.stage.stageWidth = 960;
				_starling.stage.x = (1136-960)>>1 ;
			}else {
				//iphone4,4s,3GS
				GameSetting.isIpad = false ;
				GameSetting.SCREEN_HEIGHT =_starling.stage.stageHeight  = 640 ;
				GameSetting.SCREEN_WIDTH = _starling.stage.stageWidth = 960;
			}

			_starling.start();
		}
	}
}