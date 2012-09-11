package local.view
{
	import flash.events.Event;
	
	import local.comm.GameSetting;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.bottombar.BottomBar;
	import local.view.topbar.TopBar;
	
	public class CenterViewLayer extends BaseView
	{
		private static var _instance:CenterViewLayer;
		public static function get instance():CenterViewLayer
		{
			if(!_instance) _instance = new CenterViewLayer();
			return _instance; 
		}
		//======================================
		public var bottomBar:BottomBar;
		public var topBar:TopBar ;
		
		public function CenterViewLayer()
		{
			super();
			if(_instance) throw new Error("只能实例化一个CenterViewContainer");
			else _instance=this ;
			mouseEnabled = false ;	
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			bottomBar = new BottomBar();
			bottomBar.y=GameSetting.SCREEN_HEIGHT;
			addChild(bottomBar);
			
			topBar = new TopBar();
			addChild(topBar);
			topBar.x = (GameSetting.SCREEN_WIDTH-topBar.width)>>1 ;
			
			addChild(PopUpManager.instance);
		}
	}
}