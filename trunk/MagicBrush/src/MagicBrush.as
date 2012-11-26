package
{
	import bing.res.ResVO;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import game.comm.GameSetting;
	import game.gui.GUILayer;
	import game.util.PopUpManager;
	import game.util.ResourceUtil;

	public class MagicBrush extends Sprite
	{
		public function MagicBrush()
		{
			super();
			
			// 支持 autoOrient
			stage.frameRate = 30 ;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.color = 0x323232 ;
			stage.quality="low";
			
			if(stage.fullScreenWidth%1024==0){
				//ipad1,2,3
				GameSetting.isPad = true ;
				GameSetting.SCREEN_HEIGHT = 768 ;
				GameSetting.SCREEN_WIDTH = 1024;
				GameSetting.canvasW = 800 ;
				GameSetting.canvasH = 600 ;
				if(stage.fullScreenWidth==2048){
					scaleX = scaleY = 2;
				}
			}else if( stage.stage.fullScreenHeight%1136==0){
				//iphone5
				GameSetting.SCREEN_HEIGHT  = 640 ;
				GameSetting.SCREEN_WIDTH  = 1136;
				GameSetting.canvasW = 800 ;
				GameSetting.canvasH = 480 ;
			}else {
				//iphone4,4s,3GS
				GameSetting.SCREEN_HEIGHT =640 ;
				GameSetting.SCREEN_WIDTH = 960;
				GameSetting.canvasW = 640 ;
				GameSetting.canvasH = 480 ;
				if(stage.fullScreenWidth<960){
					scaleX = scaleY = 0.5 ;
				}
			}
			
			loadRes();
		}
		
		private function loadRes():void
		{
			var resVOs:Array = [] ;
			resVOs.push( new ResVO("GUI" , "GUI.swf",false) );
			ResourceUtil.instance.addEventListener("APP_RES" , resLoadedHandler );
			ResourceUtil.instance.queueLoad( "APP_RES" , resVOs );
		}
		
		private function resLoadedHandler( e:Event ):void
		{
			ResourceUtil.instance.removeEventListener("APP_RES" , resLoadedHandler );
			initApp();
		}
		
		private function initApp():void
		{
			addChild( new GUILayer);
			addChild(PopUpManager.instance);
//			addChild( new Stats );
		}
	}
}