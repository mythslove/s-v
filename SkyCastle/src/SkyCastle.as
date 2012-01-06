package
{
	import flash.display.Sprite;
	import flash.display.StageQuality;
	
	[SWF( width="760",height="640")]
	public class SkyCastle extends Sprite
	{
		public function SkyCastle()
		{
			stage.align="TL";
			stage.scaleMode = "noScale";
			stage.quality = StageQuality.MEDIUM;
		}
	}
}