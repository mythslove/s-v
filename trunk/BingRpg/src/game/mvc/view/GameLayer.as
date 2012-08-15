package game.mvc.view
{
	import game.mvc.view.components.BaseView;
	import game.mvc.view.map.GroundLayer;
	import game.mvc.view.map.ItemLayer;
	
	public class GameLayer extends BaseView
	{
		private var _mediator:GameLayerMediator ;
		public var groundLayer:GroundLayer ;
		public var itemLayer:ItemLayer;
		
		public function GameLayer()
		{
			super();
			this.mouseChildren = false;
			this.visible = false ;
			_mediator = new GameLayerMediator( this );
		}
		
		override protected function addToStage():void
		{
			groundLayer = new GroundLayer();
			addChild(groundLayer);
			
			itemLayer = new ItemLayer();
			addChild ( itemLayer );
		}
	}
}