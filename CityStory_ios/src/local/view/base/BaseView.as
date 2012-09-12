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
		
		protected function addedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE , removedFromStageHandler,false,0,true);
		}
		
		protected function removedFromStageHandler( e:Event ):void
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler,false,0,true);
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE , removedFromStageHandler);
		}
	}
}