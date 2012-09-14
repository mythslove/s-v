package
{
	import bing.res.ResLoadedEvent;
	import bing.res.ResProgressEvent;
	import bing.res.ResVO;
	
	import flash.desktop.NativeApplication;
	import flash.display.*;
	import flash.events.Event;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import local.comm.GameSetting;
	import local.model.CompsModel;
	import local.model.LandModel;
	import local.model.PlayerModel;
	import local.model.QuestModel;
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
			NativeApplication.nativeApplication.executeInBackground = true ;
				
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
//				GameSetting.device = "ipad";
//			}
//			else 
//			{
//				if(Capabilities.screenResolutionY==2048){
//					this.scaleX = 2;
//					this.scaleY = 2;
//				}
//				GameSetting.SCREEN_WIDTH = 1024;
//				GameSetting.SCREEN_HEIGHT = 768;
//				GameSetting.minZoom = 0.4 ;
//				GameSetting.device = "ipad";
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
			try{
				bytes.uncompress();
			}finally{
				ShopModel.instance.allBuildingHash = bytes.readObject() as Dictionary ;
				ShopModel.instance.baseBuildings = bytes.readObject() as Vector.<BaseBuildingVO> ;
				LandModel.instance.expands = bytes.readObject() as Vector.<ExpandVO>;
				PlayerModel.instance.levels =  bytes.readObject() as Dictionary ;
				CompsModel.instance.allCompsHash = bytes.readObject() as Dictionary ;
				QuestModel.instance.allQuestArray = bytes.readObject() as Vector.<QuestVO>  ;
			}
			
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
			resVOs.push( new ResVO("ui_bar","swf/"+GameSetting.device+"/bar.swf"));
			resVOs.push( new ResVO("ui_popup","swf/"+GameSetting.device+"/popup.swf"));
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
						trace( Math.ceil( (e as ResProgressEvent ).loaded / (e as ResProgressEvent ).total *100 )+"%"  );
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
			ShopModel.instance.initShopDataAndRender();
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
			registerClassAlias( "ComponentVO" , ComponentVO );
			registerClassAlias( "QuestVO" , QuestVO );
			registerClassAlias( "QuestTaskVO" , QuestTaskVO );
		}
	}
}