package game.mvc.view.popup
{
	import flash.display.Sprite;
	
	import game.utils.PopUpManager;
	
	public class PopupContainer extends Sprite
	{
		
		public function PopupContainer()
		{
			super();
			PopUpManager.popUpLayer = this ;
		}
	}
}