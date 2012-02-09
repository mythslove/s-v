package game.views
{
	import flash.display.Sprite;
	import flash.events.Event;
	
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
			
		}
	}
}