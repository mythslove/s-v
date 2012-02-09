package game.views.slotlist
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import game.vos.SlotItemVO;

	public class HallItem extends MovieClip
	{
		public var itemVO:SlotItemVO ;
		
		public function HallItem( vo:SlotItemVO )
		{
			super();
			this.itemVO = vo ;
			stop();
			addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
		}
		
		private function addedToStageHandler( e:Event ):void
		{
			addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			addEventListener(Event.REMOVED_FROM_STAGE , removedHandler );
			
			
		}
		
		private function removedHandler( e:Event ):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE , removedHandler );
		}
	}
}