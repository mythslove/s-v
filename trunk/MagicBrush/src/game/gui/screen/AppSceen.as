package game.gui.screen
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import game.comm.GameSetting;
	import game.core.GraphicsLayer;
	import game.gui.app.LayerControl;
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
		public var layerControl:LayerControl ;
		
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
			
			layerControl = new LayerControl();
			layerControl.y = GameSetting.SCREEN_HEIGHT-layerControl.height-10 ;
			addChild(layerControl);
			layerControl.addEventListener("layerChanged" , layerChangedHandler);
		}
		
		private function layerChangedHandler(e:Event):void
		{
			if(layerControl.selectedLayer==1){
				graphicsLayer.selectedLayer = graphicsLayer.layer1 ;
			}else if(layerControl.selectedLayer==2){
				graphicsLayer.selectedLayer = graphicsLayer.layer2 ;
			}else{
				graphicsLayer.selectedLayer = graphicsLayer.layer3 ;
			}
		}
	}
}