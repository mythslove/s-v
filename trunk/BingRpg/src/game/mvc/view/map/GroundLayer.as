package game.mvc.view.map
{
	import flash.display.Sprite;
	
	public class GroundLayer extends Sprite
	{
		private var _Mediator:GroundLayerMediator ;
		
		public function GroundLayer()
		{
			super();
			this.mouseChildren = this.mouseEnabled = false ;
			_Mediator = new GroundLayerMediator( this );
		}
	}
}