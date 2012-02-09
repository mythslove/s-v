package game.views
{
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	
	import game.comm.GameSetting;
	import game.comm.GlobalDispatcher;
	import game.comm.GlobalEvent;
	import game.utils.PopUpManager;
	import game.views.topbars.TopBar;
	
	public class CenterView extends Sprite
	{
		private static var _instance:CenterView ;
		public static function get instance():CenterView
		{
			if(!_instance){
				_instance=  new CenterView();
			}
			return _instance ;
		}
		//--------------------------------------------
		private var _topBar:TopBar ;
		private var _container:Sprite ;
		
		public function CenterView()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
		}
		
		private function addedToStageHandler( e:Event ):void
		{
			initLayers();
			configListeners();
		}
		
		private function initLayers():void
		{
			_topBar = new TopBar();
			addChild(_topBar);
			
			_container = new Sprite();
			_container.y = 30 ;
			addChild(_container);
			
			addChild( PopUpManager.instance );
		}
		
		private function configListeners():void
		{
			GlobalDispatcher.instance.addEventListener(GlobalEvent.RESIZE , onResizeHandler );
		}
		
		private function onResizeHandler(e:Event):void
		{
			x = (stage.stageWidth-GameSetting.SCREEN_WIDTH)>>1;
			PopUpManager.instance.y = (stage.stageHeight-GameSetting.SCREEN_HEIGHT)>>1;
			
			if(stage.displayState==StageDisplayState.NORMAL && _topBar.btnFullScreen.selected)
			{
				_topBar.btnFullScreen.selected=false;
			}
		}
	}
}