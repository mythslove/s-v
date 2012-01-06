package
{
	import flash.display.Sprite;
	import flash.display.StageQuality;
	
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
			
			registerVOs();
			initGame();
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