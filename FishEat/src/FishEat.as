package
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import local.game.GameWorld;
	
	import starling.core.Starling;
	
	[SWF(width="960",height="640",frameRate="60")]
	public class FishEat extends Sprite
	{
		private var _starling:Starling ;
		
		public function FishEat()
		{
			super();
			
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = true; // not necessary on iOS. Saves a lot of memory!
			
			
			_starling = new Starling( GameWorld , stage , null ,  null, "auto", "baseline" );
			_starling.showStats = true ;
			_starling.antiAliasing = 0 ;
			_starling.enableErrorChecking = false ;
			_starling.start();
		}
	}
}