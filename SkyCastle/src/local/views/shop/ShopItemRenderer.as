package local.views.shop
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	import local.views.BaseView;
	
	public class ShopItemRenderer extends MovieClip
	{
		public var txtName:TextField;
		//==========================
		
		public function ShopItemRenderer()
		{
			super();
			mouseChildren = false ;
			stop();
			addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler , false , 0 , true  );
		}
		
		private function addedToStageHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			addEventListener( Event.REMOVED_FROM_STAGE , removedFromStageHandler , false , 0 , true  );
			
			
		}
		
		private function removedFromStageHandler( e:Event ):void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE , removedFromStageHandler);
		}
	}
}