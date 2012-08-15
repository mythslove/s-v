package game.mvc.view
{
	import flash.display.DisplayObjectContainer;
	
	import game.mvc.base.GameMediator;
	
	public class UILayerMediator extends GameMediator
	{
		public function get uiLayer():UILayer
		{
			return this.view as UILayer ;
		}
		
		public function UILayerMediator(view:DisplayObjectContainer)
		{
			super(view);
		}
	}
}