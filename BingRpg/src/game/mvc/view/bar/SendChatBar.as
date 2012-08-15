package game.mvc.view.bar
{
	import bing.components.button.BaseButton;
	
	import flash.text.TextField;
	
	import game.mvc.view.components.BaseView;
	
	public class SendChatBar extends BaseView
	{
		public var groupListBtn:BaseButton;
		public var currentGroupTxt:TextField;
		public var inputTxt:TextField;
		public var sendBtn:BaseButton;
		//============================
		
		public function SendChatBar()
		{
			super();
		}
	}
}