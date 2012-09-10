package
{
	import bing.res.ResLoadedEvent;
	import bing.res.ResProgressEvent;
	import bing.res.ResVO;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import local.comm.GameSetting;
	import local.model.LandModel;
	import local.model.PlayerModel;
	import local.model.ShopModel;
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
			loadConfig();
		}
		
		private function loadConfig():void
		{
			ResourceUtil.instance.addEventListener("GameConfig" , gameConfigHandler );
			ResourceUtil.instance.loadRes( new ResVO("GameConfig" , "config/config_"+GameSetting.local+".bin") );
		}
		
		private function gameConfigHandler( e:ResLoadedEvent ):void
		{
			ResourceUtil.instance.removeEventListener("GameConfig" , gameConfigHandler );
			var bytes:ByteArray = e.resVO.resObject as ByteArray;
			ShopModel.instance.parseConfig(  bytes.readObject() as Dictionary ) ;
			LandModel.instance.expands = bytes.readObject() as Vector.<ExpandVO>;
			PlayerModel.instance.levels =  bytes.readObject() as Dictionary ;
			ResourceUtil.instance.deleteRes( "GameConfig");
			loadRes();
		}
				
		
		
		
		
		
		/*加载初始资源*/
		private function loadRes():void
		{
			var resVOs:Array = [] ;
			var allBuildingHash:Dictionary = ShopModel.instance.allBuildingHash ;
			if( allBuildingHash){
				var baseVO:BaseBuildingVO ;
				for ( var name:String in allBuildingHash){
					baseVO =  allBuildingHash[name] as BaseBuildingVO ;
					if(baseVO.url){
						resVOs.push( new ResVO(name , baseVO.url ) ) ;
					}
				}
			}
			resVOs.push( new ResVO("ui_bar","swf/bar.swf"));
			resVOs.push( new ResVO("ui_popup","swf/popup.swf"));
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
					ResourceUtil.instance.removeEventListener(ResProgressEvent.RES_LOAD_PROGRESS , gameInitResHandler );
					ResourceUtil.instance.removeEventListener("gameInitRes" , gameInitResHandler );
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
			registerClassAlias( "ExpandVO" , ExpandVO );
			registerClassAlias( "ProductVO" , ProductVO );
		}
	}
}