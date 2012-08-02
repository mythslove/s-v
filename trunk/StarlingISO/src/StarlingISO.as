package
{
	import bing.starling.iso.SIsoUtils;
	
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.geom.Vector3D;
	
	import local.MainGame;
	
	import starling.core.Starling;
	
	[SWF(width="960",height="640",frameRate="60",backgroundColor=0)]
	public class StarlingISO extends Sprite
	{
		private var _starling:Starling ;
		
		public function StarlingISO()
		{
			stage.align = "TL";
			stage.scaleMode = "noScale";
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = true; // not necessary on iOS. Saves a lot of memory!
			
			_starling = new Starling( MainGame , stage );
			_starling.antiAliasing = 1 ;
			_starling.enableErrorChecking = false ;
			_starling.start();
		}
	}
}