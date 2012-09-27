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
			
			_starling = new Starling( MainGame , stage , new Rectangle(0,0,GameSetting.SCREEN_WIDTH,GameSetting.SCREEN_HEIGHT)
				,  null, "auto", "baseline" );
			_starling.showStats = true ;
			_starling.antiAliasing = 0 ;
			_starling.enableErrorChecking = false ;
			_starling.start();
		}
	}
}