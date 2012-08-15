package game.mvc.view
{
	import flash.display.Sprite;
	
	import game.mvc.view.bar.BarContainer;
	import game.mvc.view.popup.PopTipContainer;
	import game.mvc.view.popup.PopupContainer;

	public class UILayer extends Sprite
	{
		private var _mediator:UILayerMediator ;
		
		public var barContainer:BarContainer ;
		public var popTipContainer:PopTipContainer ;
		public var popupContainer:PopupContainer ;
		
		public function UILayer()
		{
			_mediator = new UILayerMediator( this );
			initLayers();
		}
		
		private function initLayers():void
		{
			barContainer = new BarContainer();
			popupContainer = new PopupContainer();
			popTipContainer = new PopTipContainer();
			addChild( barContainer );
			addChild( popupContainer );
			addChild( popTipContainer );
		}
	}
}