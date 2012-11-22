package game.gui.screen
{
	import flash.display.Sprite;

	public class MovieScreen extends Sprite
	{
		private static var _instance:MovieScreen ;
		public static function get instance():MovieScreen{
			if(!_instance) _instance = new MovieScreen();
			return _instance ;
		}
		//===================================
		
		public function MovieScreen()
		{
		}
	}
}