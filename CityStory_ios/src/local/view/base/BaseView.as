package  local.view.base
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BaseView extends Sprite
	{
		/**
		 * 构造函数
		 */
		public function BaseView()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler,false,0,true);
		}
		
		private function addedToStageHandler(event:Event):void 
		{
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