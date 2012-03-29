package local.views.topbar
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.model.map.BasicBuildingModel;
	import local.views.BaseView;
	import local.views.tooltip.GameToolTip;
	
	public class TopBarCoin extends BaseView
	{
		public var txtValue:TextField ;
		public var btnAddCoin:SimpleButton;
		//=============================
		
		public function TopBarCoin()
		{
			super();
		}
		
		override protected function added():void
		{
			GameToolTip.instance.register(btnAddCoin , stage , "Click to add coins.");
			GameToolTip.instance.register(txtValue , stage , "COIN: Used to purchase items.");
			
			btnAddCoin.addEventListener(MouseEvent.CLICK , onClickHandler );
		}
		
		private function onClickHandler( e:MouseEvent ):void
		{
			e.stopPropagation() ;
			BasicBuildingModel.instance.send();
		}
		
		public function update(obj:Object):void
		{
			txtValue.text = String(obj) ;
		}
	}
}