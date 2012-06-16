package
{
	import app.comm.Setting;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.StageOrientationEvent;
	import flash.system.Capabilities;
	
	public class Coloring extends Sprite
	{
		public function Coloring()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//界面大小
			if(Capabilities.screenResolutionX>=1024){
				Setting.SCREEN_WID = 1024 ;
				Setting.SCREEN_HET = 768 ;
				if(Capabilities.screenResolutionX==2048){
					this.scaleX = this.scaleY = 2 ;
				}
				stage.frameRate = 30 ;
			}else if(Capabilities.screenResolutionX<=960){
				Setting.SCREEN_WID = 960 ;
				Setting.SCREEN_HET = 640 ;
				if(Capabilities.screenResolutionX==480){
					this.scaleX = this.scaleY = 0.5 ;
				}
				stage.frameRate = 24 ;
			}
			
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING , onOrientaionChange);
		}
		
		private function onOrientaionChange( e:StageOrientationEvent):void
		{
			if(e.beforeOrientation==StageOrientation.UPSIDE_DOWN || e.beforeOrientation==StageOrientation.DEFAULT)
			{
				e.preventDefault() ;
			}
		}
	}
}