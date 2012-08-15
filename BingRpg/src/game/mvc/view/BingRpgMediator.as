package game.mvc.view
{
	import flash.display.DisplayObjectContainer;
	
	import game.events.GlobalEvent;
	import game.mvc.base.GameMediator;
	
	public class BingRpgMediator extends GameMediator
	{
		public function BingRpgMediator(view:DisplayObjectContainer)
		{
			super(view);
		}
		
		override public function onRegister():void
		{
			super.onRegister() ;
			this.addContextListener( GlobalEvent.SHOW_VIEWS , showViewHandler );
		}
		
		private function showViewHandler( e:GlobalEvent ):void
		{
			e.stopPropagation() ;
			this.removeContextListener( GlobalEvent.SHOW_VIEWS , showViewHandler );
			( view as BingRpg).initLayer() ;
		}
	}
}