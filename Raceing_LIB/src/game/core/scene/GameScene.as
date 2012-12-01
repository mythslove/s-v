package game.core.scene
{
	import game.core.car.BaseCar;
	import game.core.track.BaseTrack;
	
	import starling.display.Sprite;
	
	public class GameScene extends Sprite
	{
		private var _car:BaseCar ;
		private var _track:BaseTrack;
		
		public function GameScene()
		{
			super();
			init();
		}
		
		private function init():void
		{
			
		}
	}
}