package views
{
	import comm.GameSetting;
	import comm.GlobalDispatcher;
	import comm.GlobalEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 始终居中的视图的容器 
	 * @author zzhanglin
	 */	
	public class CenterViewContainer extends Sprite
	{
		private static var _instance:CenterViewContainer;
		public static function get instance():CenterViewContainer
		{
			if(!_instance) _instance = new CenterViewContainer();
			return _instance; 
		}
		//======================================
		
		private var _bottomBar:BottomBar ;
		private var _topBar:TopBar ;
		private var _popUpContainer:PopUpContainer ;
		
		public function get bottomBar():BottomBar
		{
			return _bottomBar;
		}
		public function get topBar():TopBar
		{
			return _topBar;
		}
		public function get popUpContainer():PopUpContainer
		{
			return _popUpContainer;
		}
		
		public function CenterViewContainer()
		{
			super();
			if(_instance) throw new Error("只能实例化一个");
			else _instance=this ;
			mouseEnabled = false ;			
			addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			
			_topBar = new TopBar();
			addChild(_topBar);
			_bottomBar = new BottomBar();
			_bottomBar.y = stage.stageHeight;
			addChild(_bottomBar);
			_popUpContainer = new PopUpContainer();
			addChild(_popUpContainer);
			
			GlobalDispatcher.instance.addEventListener(GlobalEvent.RESIZE , onResizeHandler );			
		}
		
		/**
		 * 窗口大小变化时，调整UI层的位置 
		 * @param e
		 */		
		private function onResizeHandler(e:Event):void
		{
			x = (stage.stageWidth-GameSetting.SCREEN_WIDTH)>>1;
			y = (stage.stageHeight-GameSetting.SCREEN_HEIGHT)>>1;
			_bottomBar.y = stage.stageHeight;
		}
	}
}