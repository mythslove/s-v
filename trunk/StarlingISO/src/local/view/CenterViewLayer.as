package local.view
{
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	
	import local.comm.GameSetting;
	import local.view.base.BaseView;
	import local.view.bottom.BottomBar;
	
	import starling.events.Event;
	
	public class CenterViewLayer extends BaseView
	{
		private static var _instance:CenterViewLayer; 
		public static function get instance():CenterViewLayer
		{
			if(!_instance)  _instance= new CenterViewLayer();
			return _instance ;
		}
		//-----------------------------------------------------------
		
		public var bottomBar:BottomBar ;
		
		public function CenterViewLayer()
		{
			FeathersControl.defaultTextRendererFactory = function():ITextRenderer{
				return new TextFieldTextRenderer();
			}
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			
			bottomBar = new BottomBar();
			bottomBar.y = GameSetting.SCREEN_HEIGHT ;
			addChild(bottomBar);
		}
	}
}