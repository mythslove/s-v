package
{
	import flash.display.*;
	import flash.net.registerClassAlias;
	
	import local.comm.GameSetting;
	import local.vo.*;
	
	public class BaseVillage extends Sprite
	{
		public function BaseVillage()
		{
			super();
			stage.frameRate=60;
			stage.quality = StageQuality.LOW; 
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.color = 0 ;
//			if (Capabilities.screenResolutionY <=960)
//			{
//				if(Capabilities.screenResolutionY<960){
//					this.scaleX = 0.5;
//					this.scaleY = 0.5;
//				}
				GameSetting.SCREEN_WIDTH = 960;
				GameSetting.SCREEN_HEIGHT = 640;
//			}
//			else if(Capabilities.screenResolutionY <=1136)
//			{
//				GameSetting.SCREEN_WIDTH = 1136;
//				GameSetting.SCREEN_HEIGHT = 640 ;
//			}
//			else 
//			{
//				if(Capabilities.screenResolutionY==2048){
//					this.scaleX = 2;
//					this.scaleY = 2;
//				}
//				GameSetting.SCREEN_WIDTH = 1024;
//				GameSetting.SCREEN_HEIGHT = 768;
//				GameSetting.minZoom = 0.5 ;
//			}

			registerVO();
			loadRes();
		}
		
		/*加载初始资源*/
		private function loadRes():void
		{
			initGame();
		}
		
		/** 资源加载完成后 , 初始化游戏界面和游戏 */
		protected function initGame():void
		{
			
		}
		
		
		protected function removeLoading():void
		{
			
		}
		
		private function registerVO():void
		{
			registerClassAlias( "BaseBuildingVO" , BaseBuildingVO );
			registerClassAlias( "BuildingVO" , BuildingVO );
			registerClassAlias( "PlayerVO" , PlayerVO );
			registerClassAlias( "LandVO" , LandVO );
			registerClassAlias( "LevelVO" , LevelVO );
		}
	}
}