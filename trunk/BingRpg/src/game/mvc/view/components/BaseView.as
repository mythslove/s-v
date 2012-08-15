package game.mvc.view.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BaseView extends Sprite
	{
		public function BaseView()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE , removeFormStagehandler,false,0,true);
		}
		
		private function addToStageHandler(e:Event):void 
		{
			e.stopPropagation();
			removeEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			addToStage();
		}
		
		protected function addToStage():void 
		{
			
		}
		
		private function removeFormStagehandler( e:Event):void 
		{
			e.stopPropagation() ;
			removeFromStage();
		}
		
		protected function removeFromStage():void
		{
			
		}
	}
}