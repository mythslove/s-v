package views.bottom
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class SettingBarAnim extends MovieClip
	{
		public var settingBar:SettingBar ;
		//=============================
		
		public function SettingBarAnim()
		{
			super();
			init();
			this.mouseEnabled = false ;
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
			settingBar.btnDisplay.addEventListener(MouseEvent.CLICK , settingBarClickHandler );
		}
		
		private function settingBarClickHandler( e:MouseEvent):void
		{
			e.stopPropagation();
			if(settingBar.btnDisplay.selected){
				this.gotoAndPlay(2);
			}else{
				this.gotoAndPlay("hide");
			}
		}
	}
}