package local.view.base
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class MovieClipView extends MovieClip
	{
		/**
		 * 构造函数
		 */
		public function MovieClipView()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler,false,0,true);
		}
		
		private function addedToStageHandler(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE , removedFromStageHandler,false,0,true);
			addedToStage();
		}
		protected function addedToStage():void { }
		
		private function removedFromStageHandler( e:Event ):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE , removedFromStageHandler);
			removedFromStage();
		}
		protected function removedFromStage():void { }
	}
}