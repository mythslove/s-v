package game.views.slotlist
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import game.models.vos.SlotItemVO;
	/**
	 * 一个老虎机按钮,有三帧，三个状态
	 * simple,locked,soon
	 * @author zzhanglin
	 */
	public class GreenHallItem extends MovieClip
	{
		private var _itemVO:SlotItemVO ;
		
		public function GreenHallItem()
		{
			super();
			stop();
			addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
		}
		
		public function get itemVO():SlotItemVO
		{
			return _itemVO;
		}

		public function set itemVO(value:SlotItemVO):void
		{
			_itemVO = value;
		}

		private function addedToStageHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			addEventListener(Event.REMOVED_FROM_STAGE , removedHandler );
			
			
		}
		
		private function removedHandler( e:Event ):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE , removedHandler );
			_itemVO = null ;
		}
	}
}