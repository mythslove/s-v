package local.view
{
	import flash.events.Event;
	
	import local.comm.GameSetting;
	import local.enum.VillageMode;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.bottombar.BottomBar;
	import local.view.bottombar.GameTip;
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
		public var gameTip:GameTip ;
		
		public function CenterViewLayer()
		{
			super();
			if(_instance) throw new Error("只能实例化一个CenterViewContainer");
			else _instance=this ;
			mouseEnabled = false ;	
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			bottomBar = new BottomBar();
			bottomBar.y=GameSetting.SCREEN_HEIGHT;
			addChild(bottomBar);
			
			topBar = new TopBar();
			addChild(topBar);
			topBar.x = (GameSetting.SCREEN_WIDTH-topBar.width)>>1 ;
			
			gameTip = new GameTip();
			gameTip. y = GameSetting.SCREEN_HEIGHT ;
			gameTip.x  = (GameSetting.SCREEN_WIDTH-gameTip.width)>>1 ;
			addChild(gameTip);
			
			addChild(PopUpManager.instance);
		}
		
		/**
		 * 改变UI的状态， mode为VillageMode中的常量
		 * @param mode
		 */		
		public function changeStatus ( mode:String ):void
		{
			switch(mode)
			{
				case VillageMode.NORMAL :
					bottomBar.visible = true ;
					bottomBar.marketBtn.visible = true ;
					bottomBar.editorBtn.visible = true ;
					bottomBar.doneBtn.visible = false ;
					bottomBar.storageBtn.visible = false ;
					topBar.visible = true ;
					break ;
				case VillageMode.EDIT :
					bottomBar.marketBtn.visible = false ;
					bottomBar.editorBtn.visible = false ;
					bottomBar.doneBtn.visible = true ;
					bottomBar.storageBtn.visible = true ;
					topBar.visible = false ;
					break ;
				case VillageMode.BUILDING_STORAGE :
					bottomBar.doneBtn.visible = false ;
					bottomBar.storageBtn.visible = false ;
					bottomBar.showStorage();
					topBar.visible = false ;
					break ;
				case VillageMode.BUILDING_SHOP :
					bottomBar.visible = false ;
					topBar.visible = false ;
					break ;
				case VillageMode.EXPAND :
					bottomBar.visible = false ;
					topBar.visible = false ;
					break ;
			}
		}
	}
}