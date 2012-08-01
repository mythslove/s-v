package
{
	import flash.display.Sprite;
	
	import local.Game;
	
	import starling.core.Starling;
	
	[SWF(width="960",height="640",frameRate="60",backgroundColor=0)]
	public class StarlingISO extends Sprite
	{
		private var _starling:Starling ;
		
		public function StarlingISO()
		{
			stage.align = "TL";
			stage.scaleMode = "noScale";
			
			_starling = new Starling( Game , stage );
			_starling.enableErrorChecking = true ;
			_starling.start();
		}
	}
}