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
			stop();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler,false,0,true);
			addEventListener(Event.REMOVED_FROM_STAGE , removedFromStageHandler,false,0,true);
		}
		
		protected function addedToStageHandler(e:Event):void 
		{
		}
		
		protected function removedFromStageHandler( e:Event ):void
		{
		}
	}
}