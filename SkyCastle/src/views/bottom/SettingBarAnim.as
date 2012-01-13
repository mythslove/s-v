package views.bottom
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import views.tooltip.GameToolTip;
	
	public class SettingBarAnim extends MovieClip
	{
		public var settingBar:SettingBar ;
		//=============================
		private var _btnDisplayToolTips1:String="SETTINGS: Zoom in and out, toggle the music and toggle the sound effects.";
		private var _btnDisplayToolTips2:String="HIDE SETTINGS: Hide the settings bar";
		
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
			GameToolTip.instance.register( settingBar.btnDisplay , stage,_btnDisplayToolTips1);
			
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
						GameToolTip.instance.register( settingBar.btnDisplay , stage,_btnDisplayToolTips2);
					}else{
						this.gotoAndPlay("hide");
						GameToolTip.instance.register( settingBar.btnDisplay , stage,_btnDisplayToolTips1);
					}
				break;
			}
			
		}
	}
}