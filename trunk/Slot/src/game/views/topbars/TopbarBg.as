package game.views.topbars
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import game.comm.GlobalDispatcher;
	import game.comm.GlobalEvent;
	
	public class TopbarBg extends Sprite
	{
		public function TopbarBg()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
		}
		
		private function addedToStageHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			GlobalDispatcher.instance.addEventListener(GlobalEvent.RESIZE , onResizeHandler );
		}
		
		private function onResizeHandler( e:GlobalEvent ):void
		{
			this.width = stage.stageWidth ;
		}
	}
}