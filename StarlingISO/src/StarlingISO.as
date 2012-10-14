package
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import local.MainGame;
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.comm.GlobalDispatcher;
	import local.enum.VillageMode;
	import local.event.VillageEvent;
	import local.map.GameWorld;
	import local.model.PlayerModel;
	import local.util.VillageUtil;
	
	import starling.core.Starling;
	
	public class StarlingISO extends BaseVillage
	{
		private var _starling:Starling ;
		protected var _villageUtil:VillageUtil ;
		
		public function StarlingISO()
		{
			super();
		}
		
		override protected function initGame():void
		{
			super.initGame();
			
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = true; // not necessary on iOS. Saves a lot of memory!
			
			_starling = new Starling( MainGame , stage , new Rectangle(0,0,stage.fullScreenWidth,stage.fullScreenHeight) ,  null, "auto", "baseline" );
			_starling.showStats = true ;
			_starling.antiAliasing = 0 ;
			_starling.enableErrorChecking = false ;
			
			if(stage.fullScreenWidth >= 1024){
				//ipad1,2,3
				GameSetting.isIpad = true ;
				GameSetting.SCREEN_HEIGHT =_starling.stage.stageHeight  = 768 ;
				GameSetting.SCREEN_WIDTH = _starling.stage.stageWidth = 1024;
			}else if( stage.stage.fullScreenHeight >= 1136){
				//iphone5
				GameSetting.isIpad = false ;
				GameSetting.SCREEN_HEIGHT =_starling.stage.stageHeight  = 640 ;
				GameSetting.SCREEN_WIDTH = _starling.stage.stageWidth = 960;
				_starling.stage.x = (1136-960)>>1 ;
			}else {
				//iphone4,4s,3GS
				GameSetting.isIpad = false ;
				GameSetting.SCREEN_HEIGHT =_starling.stage.stageHeight  = 640 ;
				GameSetting.SCREEN_WIDTH = _starling.stage.stageWidth = 960;
			}
			_starling.start();
			
			GlobalDispatcher.instance.addEventListener( VillageEvent.READED_VILLAGE , villageEvtHandler );
			GlobalDispatcher.instance.addEventListener( VillageEvent.NEW_VILLAGE , villageEvtHandler );
			_villageUtil = new VillageUtil();
			_villageUtil.readVillage();
		}
		
		private function villageEvtHandler( e:VillageEvent ):void
		{
			if(e.type==VillageEvent.NEW_VILLAGE){
				PlayerModel.instance.createPlayer();
			}
			GlobalDispatcher.instance.removeEventListener( VillageEvent.READED_VILLAGE , villageEvtHandler );
			GlobalDispatcher.instance.removeEventListener( VillageEvent.NEW_VILLAGE , villageEvtHandler );
			
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE , activateHandler);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE , deactivateHandler );
		}
		
		private function activateHandler( e:Event ):void 
		{
			if(GameData.villageMode!=VillageMode.VISIT)
			{
				GameData.commDate = new Date();
				GameWorld.instance.buildingScene.refreshBuildingStatus();
			}
		}
		
		private function deactivateHandler( e:Event ):void 
		{
			if(GameData.villageMode!=VillageMode.VISIT)
			{
				GameWorld.instance.buildingScene.readySave();
				_villageUtil.saveVillage();
			}
		}
		
	}
}