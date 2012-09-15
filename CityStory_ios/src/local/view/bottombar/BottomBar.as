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
		public var doneBtn:DoneButton ;
		
		public function BottomBar()
		{
			super();
			mouseEnabled = false ;
		}
		
		override protected function addedToStageHandler( e:Event ):void
		{
			super.addedToStageHandler(e);
			
			marketBtn = new MarketButton();
			marketBtn.x = GameSetting.SCREEN_WIDTH-marketBtn.width-10 ;
			marketBtn.y = - marketBtn.height-10 ;
			addChild(marketBtn);
			
			
			editorBtn = new EditorButton();
			editorBtn.x = marketBtn.x-editorBtn.width-50 ;
			editorBtn.y = - editorBtn.height-10 ;
			addChild(editorBtn);
			
			doneBtn = new DoneButton();
			doneBtn.x = GameSetting.SCREEN_WIDTH-doneBtn.width-10 ;
			doneBtn.y = - doneBtn.height-10 ;
			addChild(doneBtn);
			
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
				case doneBtn:
					GameData.villageMode = VillageMode.NORMAL ;
					break ;
			}
		}
		
	}
}