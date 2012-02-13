package game.slots
{
	import bing.components.button.BaseButton;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.views.BaseView;
	
	public class ControlBar extends BaseView
	{
		public var coins:Sprite;
		public var linesValue:Sprite;
		public var betValue:Sprite;
		public var totalBetValue:Sprite;
		public var win:Sprite ;
		public var btnPlay:BaseButton;
		public var btnReduceLines:BaseButton;
		public var btnEnlargeLines:BaseButton;
		public var btnReduceBet:BaseButton;
		public var btnEnlargeBet:BaseButton;
		public var btnMaxLines:BaseButton;
		public var btnStart:BaseButton;
		//-----------------------------------------------------------------
		
		public function ControlBar()
		{
			super();
		}
		
		override protected function addedToStage():void
		{
			init();
			configListeners();
		}
		
		private function init():void
		{
			this.mouseEnabled=false ;
			coins.mouseChildren=coins.mouseEnabled=false ;
			linesValue.mouseChildren=linesValue.mouseEnabled=false ;
			betValue.mouseChildren=betValue.mouseEnabled=false ;
			totalBetValue.mouseChildren=totalBetValue.mouseEnabled=false ;
			win.mouseChildren=win.mouseEnabled=false ;
			//
			
		}
		
		private function configListeners():void
		{
			stage.addEventListener(MouseEvent.CLICK , controlBarClickHandler);
		}
		
		private function controlBarClickHandler( e:MouseEvent ):void
		{
			switch(e.target)
			{
				case btnPlay:
					
					break ;
				case btnReduceLines:
					
					break ;
				case btnEnlargeLines:
					
					break ;
				case btnReduceBet:
					
					break ;
				case btnEnlargeBet:
					
					break ;
				case btnMaxLines:
					
					break ;
				case btnStart:
					
					break ;
			}
		}
		
		private function setButtonEnabled( value:Boolean ):void
		{
			for( var i:int =0  ; i<numChildren ; ++i ) {
				if( getChildAt(i) is SimpleButton){
					( getChildAt(i) as SimpleButton ).enabled=value ;
				}
			}
		}
		
		private function refreshTotalBets():void
		{
			
		}
	}
}