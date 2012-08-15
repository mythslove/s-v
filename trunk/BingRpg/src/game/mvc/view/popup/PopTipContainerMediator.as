package game.mvc.view.popup
{
	import flash.display.DisplayObjectContainer;
	
	import game.mvc.base.GameMediator;
	
	public class PopTipContainerMediator extends GameMediator
	{
		public function get popTipContainer():PopTipContainer
		{
			return view as PopTipContainer ;
		}
		
		public function PopTipContainerMediator(view:DisplayObjectContainer)
		{
			super(view);
		}
	}
}