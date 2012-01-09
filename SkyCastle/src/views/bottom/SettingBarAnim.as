package views.bottom
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SettingBarAnim extends MovieClip
	{
		public var settingBar:SettingBar ;
		//=============================
		
		public function SettingBarAnim()
		{
			super();
			stop();
			mouseEnabled = false ;
			addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void
		{
			init();
			configListeners();
		}
		
		private function init():void
		{
			this.addFrameScript( 0,addScript,6,addScript);
			function addScript():void{
				stop();
			}
		}
		
		private function configListeners():void
		{
			settingBar.addEventListener(MouseEvent.CLICK , settingBarClickHandler );
			stage.addEventListener(MouseEvent.CLICK , stageClickHandler);
		}
		
		private function stageClickHandler(e:MouseEvent):void
		{
			if(currentFrame!=1){
				gotoAndPlay("hide");
				settingBar.btnDisplay.selected = false ;
			}
		}
		
		private function settingBarClickHandler( e:MouseEvent):void
		{
			e.stopPropagation();
			switch( e.target )
			{
				case settingBar.btnDisplay:
					if(settingBar.btnDisplay.selected){
						this.gotoAndPlay(2);
					}else{
						this.gotoAndPlay("hide");
					}
				break;
			}
			
		}
	}
}