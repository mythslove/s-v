package local.views.base
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BaseView extends Sprite
	{
		public function BaseView()
		{
			super();
			mouseEnabled = false; 
			addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler  );
		}
		
		private function addedToStageHandler ( e:Event ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE , addedToStageHandler );
			added();
			addEventListener(Event.REMOVED_FROM_STAGE , removedFromStageHandler );
		}
		
		private function removedFromStageHandler( e:Event ):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE , removedFromStageHandler );
			removed();
		}
		
		protected function added():void{}
		protected function removed():void{}
	}
}