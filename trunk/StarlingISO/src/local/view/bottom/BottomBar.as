package local.view.bottom
{
	import feathers.controls.Button;
	
	import local.comm.GameSetting;
	import local.util.EmbedManager;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.shop.ShopOverViewPopUp;
	
	import starling.display.Image;
	import starling.events.Event;
	
	public class BottomBar extends BaseView
	{
		private var _btnMarket:Button;
		
		public function BottomBar()
		{
			super();
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			_btnMarket = new Button();
			var img:Image =EmbedManager.getUIImage("MarketButtonUp");
			_btnMarket.defaultSkin = img;
			_btnMarket.validate();
			_btnMarket.x = GameSetting.SCREEN_WIDTH - img.width-5 ;
			_btnMarket.y = - img.height-5 ;
			addChild(_btnMarket);
			_btnMarket.onRelease.add( onClickHandler );
		}
		
		private function onClickHandler( btn:Button ):void
		{
			switch( btn )
			{
				case _btnMarket:
					PopUpManager.instance.addQueuePopUp( new ShopOverViewPopUp());
					break ;
			}
		}
	}
}