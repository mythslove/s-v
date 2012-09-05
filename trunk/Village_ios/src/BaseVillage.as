package
{
	import bing.res.ResLoadedEvent;
	import bing.res.ResProgressEvent;
	import bing.res.ResVO;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.net.registerClassAlias;
	
	import local.comm.GameSetting;
	import local.util.ResourceUtil;
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
			var resVOs:Array = [] ;
			resVOs.push( new ResVO("Basic_Tree1" , "basic/Basic_Tree1.bd")  ) ;
			resVOs.push( new ResVO("Basic_Tree2" , "basic/Basic_Tree2.bd")  ) ;
			resVOs.push( new ResVO("Basic_Tree3" , "basic/Basic_Tree3.bd") ) ;
			resVOs.push( new ResVO("Basic_Tree4" , "basic/Basic_Tree4.bd") ) ;
			resVOs.push( new ResVO("Basic_Tree5" , "basic/Basic_Tree5.bd")  ) ;
			resVOs.push( new ResVO("Basic_Tree6" , "basic/Basic_Tree6.bd")  ) ;
			resVOs.push( new ResVO("Basic_Tree7" , "basic/Basic_Tree7.bd")  ) ;
			resVOs.push( new ResVO("Basic_Tree8" , "basic/Basic_Tree8.bd") ) ;
			resVOs.push( new ResVO("Road" , "decoration/Road.rd")  ) ;
			resVOs.push( new ResVO("Home1" , "home/Home1.bd") ) ;
			ResourceUtil.instance.addEventListener(ResProgressEvent.RES_LOAD_PROGRESS , gameInitResHandler );
			ResourceUtil.instance.addEventListener("gameInitRes" , gameInitResHandler );
			ResourceUtil.instance.queueLoad( "gameInitRes" , resVOs , 10 );
		}
		
		private function gameInitResHandler( e:Event ):void
		{
			switch( e.type )
			{
				case ResProgressEvent.RES_LOAD_PROGRESS:
					if((e as ResProgressEvent ).queueName=="gameInitRes"){
						trace(  (e as ResProgressEvent ).loaded / (e as ResProgressEvent ).total *100 +"%"  );
					}
					break ;
				case "gameInitRes":
					initGame();
					break ;
			}
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
			registerClassAlias( "StorageBuildingVO" , StorageBuildingVO );
		}
	}
}