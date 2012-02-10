package game.views
{
	import bing.utils.ContainerUtil;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	
	import game.comm.GameSetting;
	import game.comm.GlobalDispatcher;
	import game.comm.GlobalEvent;
	import game.utils.PopUpManager;
	import game.views.slotlist.HallCenterView;
	import game.views.topbars.TopBar;
	/**
	 * 一直居中的容器 
	 * @author zzhanglin
	 */	
	public class CenterView extends BaseView
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
		}
		
		override protected function addedToStage():void
		{
			initLayers();
			configListeners();
		}
		
		private function initLayers():void
		{
			_container = new Sprite();
			_container.y = 30 ;
			addChild(_container);
			
			_topBar = new TopBar();
			addChild(_topBar);
			
			addChild( PopUpManager.instance );
			
			//默认显示大厅
			showHall();
		}
		
		private function configListeners():void
		{
			GlobalDispatcher.instance.addEventListener(GlobalEvent.RESIZE , onResizeHandler );
		}
		
		private function onResizeHandler(e:Event):void
		{
			x = (stage.stageWidth-GameSetting.SCREEN_WIDTH)>>1;
			y = (stage.stageHeight-GameSetting.SCREEN_HEIGHT)>>1;
			_topBar.y=-y;
			if(stage.displayState==StageDisplayState.NORMAL && _topBar.btnFullScreen.selected)
			{
				_topBar.btnFullScreen.selected=false;
			}
		}
		
		public function showHall():void
		{
			ContainerUtil.removeChildren(_container);
			var hallView:HallCenterView = new HallCenterView();
			_container.addChild(hallView);
		}
	}
}