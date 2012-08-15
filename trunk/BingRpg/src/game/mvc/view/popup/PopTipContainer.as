package game.mvc.view.popup
{
	import flash.display.Sprite;
	
	public class PopTipContainer extends Sprite
	{
		private var _mediator:PopTipContainerMediator;
		
		public function PopTipContainer()
		{
			super();
			_mediator = new PopTipContainerMediator( this ) ;
		}
	}
}