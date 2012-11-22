package game.gui.app
{
	import flash.display.Sprite;
	
	import game.comm.GameSetting;
	
	public class ToolBar extends Sprite
	{
		public function ToolBar()
		{
			super();
			mouseEnabled = false ;
			graphics.beginFill(0,0.7);
			graphics.drawRect(0,0,100,GameSetting.SCREEN_HEIGHT);
			graphics.endFill();
		}
	}
}