package game.gui.screen
{
	import flash.display.Sprite;
	
	public class HomeScreen extends Sprite
	{
		private static var _instance:HomeScreen ;
		public static function get instance():HomeScreen{
			if(!_instance) _instance = new HomeScreen();
			return _instance ;
		}
		//===================================
		
		public function HomeScreen()
		{
			super();
		}
	}
}