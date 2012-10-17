package local.view.iap
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.view.control.Button;
	
	public class PopUpCashButton extends Button
	{
		public var txtPrice:TextField ;
		
		public function PopUpCashButton()
		{
			super();
		}
		
		
		override protected function addedToStageHandler(e:Event):void{
			super.addedToStageHandler(e);
			addEventListener(MouseEvent.CLICK , onClickHandler );
		}
		
		private function onClickHandler( e:MouseEvent ):void
		{
			e.stopPropagation() ;
			
		}
		
		override protected function removedFromStageHandler(e:Event):void{
			super.removedFromStageHandler(e);
			removeEventListener(MouseEvent.CLICK , onClickHandler );
		}
	}
}