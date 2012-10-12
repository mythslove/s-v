package  local.view.base
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class BaseView extends Sprite
	{
		/**
		 * 构造函数
		 */
		public function BaseView()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		protected function addedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE , removedFromStageHandler);
		}
		
		protected function removedFromStageHandler( e:Event ):void
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE , removedFromStageHandler);
		}
	}
}