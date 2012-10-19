package local.view
{
	import feathers.controls.Button;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.display.Sprite;
	
	import local.comm.GameSetting;
	import local.enum.VillageMode;
	import local.util.EmbedManager;
	import local.view.base.GameButton;
	import local.view.bottom.BottomBar;
	import local.view.topbar.TopBar;
	
	import starling.display.Image;
	
	public class CenterViewLayer extends Sprite
	{
		private static var _instance:CenterViewLayer; 
		public static function get instance():CenterViewLayer
		{
			if(!_instance)  _instance= new CenterViewLayer();
			return _instance ;
		}
		//-----------------------------------------------------------
		
		public var topBar:TopBar ;
		public var bottomBar:BottomBar ;
		public var questBtn:GameButton; 
		
		public function CenterViewLayer()
		{
			FeathersControl.defaultTextRendererFactory = function():ITextRenderer{
				return new TextFieldTextRenderer();
			};
			init();
		}

		private function init():void
		{
			bottomBar = new BottomBar();
			bottomBar.y = GameSetting.SCREEN_HEIGHT ;
			addChild(bottomBar);
			
			topBar = new TopBar();
			topBar.x = (GameSetting.SCREEN_WIDTH-topBar.width)>>1; 
			addChild(topBar);
			
			var img:Image = EmbedManager.getUIImage("QuestButtonUp") ;
			questBtn = new GameButton( img );
			questBtn.x= img.width*0.5 + 5;
			questBtn.y = 100 ;
			addChild(questBtn);
			questBtn.onRelease.add( questBtnClick );
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
					bottomBar.btnMarket.visible = true ;
					bottomBar.btnEditor.visible = true ;
					questBtn.visible = true ;
					bottomBar.btnDone.visible = false ;
					bottomBar.btnStorage.visible = false ;
					topBar.visible = true ;
					break ;
				case VillageMode.EDIT :
					bottomBar.btnMarket.visible = false ;
					bottomBar.btnEditor.visible = false ;
					questBtn.visible = false ;
					bottomBar.btnDone.visible = true ;
					bottomBar.btnStorage.visible = true ;
					topBar.visible = false ;
					break ;
				case VillageMode.BUILDING_STORAGE :
					bottomBar.btnDone.visible = false ;
					bottomBar.btnStorage.visible = false ;
					questBtn.visible = false ;
					bottomBar.showStorage();
					topBar.visible = false ;
					break ;
				case VillageMode.BUILDING_SHOP :
					bottomBar.visible = false ;
					topBar.visible = false ;
					questBtn.visible = false ;
					break ;
				case VillageMode.EXPAND :
					bottomBar.btnMarket.visible = false ;
					bottomBar.btnEditor.visible = false ;
					questBtn.visible = false ;
					bottomBar.btnDone.visible = true ;
					bottomBar.btnStorage.visible = false ;
					topBar.visible = false ;
					break ;
				case VillageMode.VISIT:
//					gameTip.hide();
					bottomBar.btnMarket.visible = false ;
					bottomBar.btnEditor.visible = false ;
					questBtn.visible = false ;
					break ;
			}
		}
		
		private function questBtnClick( btn:Button ):void
		{
			
		}
		
		
		
		
		
		
		
		
		
		public function set enable( value:Boolean ):void
		{
			touchable = value ;
			alpha = value ? 1 : 0.5 ;
		}
	}
}