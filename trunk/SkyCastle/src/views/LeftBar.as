package views
{
	import flash.display.Sprite;
	
	public class LeftBar extends Sprite
	{
		private static var _instance:LeftBar ;
		public static function get instance():LeftBar
		{
			if(!_instance) _instance = new LeftBar();
			return _instance;
		}
		public function LeftBar()
		{
			super();
			if(_instance) throw new Error(" 只能实例化一个LeftBar");
			else _instance = this ;
			mouseEnabled = false ;			
		}
	}
}