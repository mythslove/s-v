package game.gui.screen
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import game.core.GraphicsLayer;
	import game.gui.app.ToolBar;
	
	public class AppSceen extends Sprite
	{
		private static var _instance:AppSceen ;
		public static function get instance():AppSceen{
			if(!_instance) _instance = new AppSceen();
			return _instance ;
		}
		//===================================
		
		public var graphicsLayer:GraphicsLayer ;
		public var toolBar:ToolBar ;
		
		public function AppSceen()
		{
			super();
			mouseEnabled = false ;
			init();
		}
		
		private function init():void
		{
			graphicsLayer = new GraphicsLayer();
			addChild(graphicsLayer);
			toolBar = new ToolBar();
			addChild(toolBar);
		}
	}
}