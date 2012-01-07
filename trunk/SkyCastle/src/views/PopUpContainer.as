package views
{
	import flash.display.Sprite;

	public class PopUpContainer extends Sprite
	{
		private static var _instance:PopUpContainer;
		public static function get instance():PopUpContainer
		{
			if(!_instance) _instance = new PopUpContainer();
			return _instance; 
		}
		//======================================
		public function PopUpContainer()
		{
			super();
			if(_instance) throw new Error("只能实例化一个");
			else _instance=this ;
			mouseEnabled = false ;
		}
	}
}