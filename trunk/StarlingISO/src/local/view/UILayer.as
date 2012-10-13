package local.view
{
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	
	import local.comm.GameSetting;
	import local.view.base.BaseView;
	import local.view.bottom.BottomBar;
	
	import starling.events.Event;
	
	public class UILayer extends BaseView
	{
		private static var _instance:UILayer; 
		public static function get instance():UILayer
		{
			if(!_instance)  _instance= new UILayer();
			return _instance ;
		}
		//-----------------------------------------------------------
		
		public var bottomBar:BottomBar ;
		
		public function UILayer()
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