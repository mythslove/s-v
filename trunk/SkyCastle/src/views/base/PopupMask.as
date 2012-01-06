package  views.base
{
	import comm.GameSetting;
	import comm.GlobalDispatcher;
	import comm.GlobalEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * popup窗口弹出时，遮挡下面的内容 
	 * @author zzhanglin
	 */	
	public class PopupMask extends Sprite
	{
		public function PopupMask( color:uint=0 , alpha:Number =0.5 )
		{
			super();
			this.graphics.beginFill( color , alpha );
			this.graphics.drawRect(0,0,GameSetting.SCREEN_WIDTH,GameSetting.SCREEN_HEIGHT );
			this.graphics.endFill() ;
			
			addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler );
		}
		
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler);
			this.width = stage.stageWidth ;
			this.height = stage.stageHeight;
			
			GlobalDispatcher.instance.addEventListener( GlobalEvent.RESIZE , onResizeHandler );
			addEventListener(Event.REMOVED_FROM_STAGE , removedFromStageHandler);
		}
		
		private function onResizeHandler(e:GlobalEvent):void
		{
			this.width = stage.stageWidth ;
			this.height = stage.stageHeight;
		}
		
		private function removedFromStageHandler(e:Event):void
		{
			GlobalDispatcher.instance.removeEventListener( GlobalEvent.RESIZE , onResizeHandler );
			removeEventListener(Event.REMOVED_FROM_STAGE , removedFromStageHandler);
		}
		
	}
}