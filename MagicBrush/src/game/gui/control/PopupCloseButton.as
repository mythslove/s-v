package game.gui.control
{
	

	public class PopupCloseButton extends Button
	{
		[Embed(source="../assets/PopupCloseBtnUp.png")]
		public static const PopupCloseBtnUp:Class;
		[Embed(source="../assets/PopupCloseBtnDown.png")]
		public static const PopupCloseBtnDown:Class;
		
		public function PopupCloseButton()
		{
			super( new PopupCloseBtnUp() , new PopupCloseBtnDown() , null , null , true);
		}
	}
}