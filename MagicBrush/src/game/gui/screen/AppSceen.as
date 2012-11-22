package game.gui.screen
{
	import flash.display.Sprite;
	
	public class AppSceen extends Sprite
	{
		private static var _instance:AppSceen ;
		public static function get instance():AppSceen{
			if(!_instance) _instance = new AppSceen();
			return _instance ;
		}
		//===================================
		
		public function AppSceen()
		{
			super();
		}
	}
}