package
{
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.net.registerClassAlias;
	
	[SWF( width="760",height="640")]
	public class SkyCastle extends Sprite
	{
		public function SkyCastle()
		{
			super();
			stage.align="TL";
			stage.scaleMode = "noScale";
			stage.quality = StageQuality.MEDIUM;
			
			registerVOs();
		}
		
		private function registerVOs():void
		{
			
		}
		
	}
}