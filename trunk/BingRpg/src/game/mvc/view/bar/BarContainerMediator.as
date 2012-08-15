package game.mvc.view.bar
{
	import flash.display.DisplayObjectContainer;
	
	import game.mvc.base.GameMediator;
	
	public class BarContainerMediator extends GameMediator
	{
		public function get barContainer():BarContainer
		{
			return view as BarContainer ;
		}
		public function BarContainerMediator(view:DisplayObjectContainer)
		{
			super(view);
		}
		
	}
}