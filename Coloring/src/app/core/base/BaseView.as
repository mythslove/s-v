package app.core.base
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BaseView extends Sprite
	{
		public function BaseView()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler , false , 0 , true );
		}
		
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE , addedToStageHandler );
			addEventListener(Event.REMOVED_FROM_STAGE , removedFromStageHandler , false , 0 , true );
			addedToStage();
		}
		
		private function removedFromStageHandler(e:Event):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE , removedFromStageHandler , false , 0 , true );
			removedFromStage();
		}
		
		protected function addedToStage():void { }
		protected function removedFromStage():void { }
		
	}
}