package game.slots
{
	import bing.components.button.BaseButton;
	
	import flash.display.Sprite;
	
	import game.views.BaseView;
	
	public class ControlBar extends BaseView
	{
		public var coins:Sprite;
		public var linesValue:Sprite;
		public var betValue:Sprite;
		public var totalBetValue:Sprite;
		public var win:Sprite ;
		public var btnPlay:BaseButton;
		public var btnReduceLines:BaseButton;
		public var btnEnlargeLines:BaseButton;
		public var btnReduceBet:BaseButton;
		public var btnEnlargeBet:BaseButton;
		public var btnMaxLines:BaseButton;
		public var btnStart:BaseButton;
		//-----------------------------------------------------------------
		
		public function ControlBar()
		{
			super();
		}
	}
}