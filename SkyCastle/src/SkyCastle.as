package
{
	import map.GameWorld;
	
	[SWF( width="760",height="640")]
	public class SkyCastle extends BaseGame
	{
		public function SkyCastle()
		{
			super();
		}
		
		override protected function inited():void
		{
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