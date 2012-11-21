package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import game.comm.GameSetting;
	import game.core.GraphicsLayer;
	import game.gui.GUILayer;
	
	public class MagicBrush extends Sprite
	{
		public function MagicBrush()
		{
			super();
			
			// 支持 autoOrient
			stage.frameRate = 30 ;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.color = 0xD4D4D4 ;
			
			if(stage.fullScreenWidth >= 1024){
				//ipad1,2,3
				GameSetting.isPad = true ;
				GameSetting.SCREEN_HEIGHT = 768 ;
				GameSetting.SCREEN_WIDTH = 1024;
				if(stage.fullScreenWidth==2048){
					scaleX = scaleY = 2;
				}
			}else if( stage.stage.fullScreenHeight >= 1136){
				//iphone5
				GameSetting.SCREEN_HEIGHT  = 640 ;
				GameSetting.SCREEN_WIDTH  = 960;
			}else {
				//iphone4,4s,3GS
				GameSetting.SCREEN_HEIGHT =640 ;
				GameSetting.SCREEN_WIDTH = 960;
				if(stage.fullScreenWidth<960){
					scaleX = scaleY = 0.5 ;
				}
			}
			
			init();
		}
		
		private function init():void
		{
			addChild( new GraphicsLayer );
			addChild( new GUILayer);
//			addChild( new Stats );
		}
	}
}