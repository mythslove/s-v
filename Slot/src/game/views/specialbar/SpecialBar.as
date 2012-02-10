package game.views.specialbar
{
	import bing.components.button.BaseButton;
	
	import game.views.BaseView;
	
	public class SpecialBar extends BaseView
	{
		public var btnSendGift:BaseButton;
		public var btnReceiveGift:BaseButton;
		public var specialGame:SpecialGame;
		//-------------------------------------------------------
		
		public function SpecialBar()
		{
			super();
		}
		
		override protected function addedToStage():void
		{
			btnReceiveGift.enabled=false;
		}
	}
}