package local.game
{
	import local.comm.GameSetting;

	public class GameWorld extends BaseWorld
	{
		private static var _instance:GameWorld;
		public static function get instance():GameWorld{
			if(!_instance) _instance = new GameWorld();
			return _instance ;
		}
		//------------------------------------------------------------
		public function GameWorld()
		{
			super();
		}
		
		public function start():void
		{
			
		}
		
		public function stop():void
		{
			
		}
	}
}