package local.view.bottombar
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.VillageMode;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.shop.ShopOverViewPopUp;
	
	public class BottomBar extends BaseView
	{
		public var editorBtn:EditorButton ;
		public var marketBtn:MarketButton;
		
		public function BottomBar()
		{
			super();
			mouseEnabled = false ;
		}
		
		override protected function addedToStageHandler( e:Event ):void
		{
			super.addedToStageHandler(e);
			editorBtn = new EditorButton();
			editorBtn.x = GameSetting.SCREEN_WIDTH-200 ;
			editorBtn.y = - 80 ;
			addChild(editorBtn);
			
			marketBtn = new MarketButton();
			marketBtn.x = GameSetting.SCREEN_WIDTH-100 ;
			marketBtn.y = - 80 ;
			addChild(marketBtn);
			
			addEventListener(MouseEvent.CLICK , onMouseHandler );
		}
		
		private function onMouseHandler( e:MouseEvent):void
		{
			switch(e.target)
			{
				case editorBtn:
					GameData.villageMode = VillageMode.EDIT ;
					break ;
				case marketBtn:
					PopUpManager.instance.addQueuePopUp( ShopOverViewPopUp.instance , true , 0 , 0 );
					break ;
			}
		}
		
	}
}