package game.mvc.view.bar
{
	import game.mvc.base.GameContext;
	import game.mvc.view.components.BaseView;
	
	public class BarContainer extends BaseView
	{
		public var mapBar:MapBar ;
		public var chatBar:ChatBar ;
		
		public function BarContainer()
		{
			super();
			this.mouseEnabled = false ;
			initBars() ;
		}
		
		private function initBars():void 
		{
			mapBar = new MapBar();
			mapBar.x = GameContext.instance.contextView.stage.stageWidth - mapBar.width ;
			addChild(mapBar);
			
			chatBar = new ChatBar();
			chatBar.y = GameContext.instance.contextView.stage.stageHeight - chatBar.height ;
			addChild(chatBar);
		}
	}
}