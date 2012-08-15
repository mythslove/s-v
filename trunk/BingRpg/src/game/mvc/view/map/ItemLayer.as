package game.mvc.view.map
{
	import flash.display.Sprite;
	
	public class ItemLayer extends Sprite
	{
		private var _mediator:ItemLayerMediator ;
		
		public function ItemLayer()
		{
			super();
			_mediator = new ItemLayerMediator(this);
		}
	}
}