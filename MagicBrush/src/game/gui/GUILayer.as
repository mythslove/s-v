package game.gui
{
	import flash.display.Sprite;
	
	import game.gui.screen.AppSceen;
	
	public class GUILayer extends Sprite
	{
		public function GUILayer()
		{
			super();
			init();
		}
		
		private function init():void
		{
			addChild( AppSceen.instance );
		}
	}
}