package game.mvc.view.bar
{
	import bing.components.button.BaseButton;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import game.mvc.view.components.BaseView;
	
	public class MapBar extends BaseView
	{
		public var mapBtn:BaseButton ;
		public var container:Sprite ;
		public var infoTxt:TextField ;
		//=======================
		private var _mediator:MapBarMediator ;
		
		public function MapBar()
		{
			super();
			_mediator = new MapBarMediator( this );
		}
	}
}