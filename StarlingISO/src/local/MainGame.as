package local
{
	import bing.starling.iso.SIsoWorld;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.comm.GlobalDispatcher;
	import local.enum.VillageMode;
	import local.event.VillageEvent;
	import local.map.GameWorld;
	import local.model.PlayerModel;
	import local.util.PopUpManager;
	import local.util.TextureAssets;
	import local.util.VillageUtil;
	import local.view.CenterViewLayer;
	
	import starling.display.*;
	import starling.events.Event;
	
	public class MainGame extends SIsoWorld
	{
		private var _villageUtil:VillageUtil ;
		
		public function MainGame()
		{
			super( GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE );
			addEventListener(starling.events.Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler(e:starling.events.Event):void
		{
			removeEventListener(starling.events.Event.ADDED_TO_STAGE , addedHandler );
			
			//动态生成材质
			TextureAssets.instance.createBuildingTexture() ;
			
//			var bmp:Bitmap = new Bitmap( TextureAssets.instance.groundLayerBmd);
//			bmp.scaleX  = bmp.scaleY = .4 ;
//			Starling.current.nativeStage.addChild(bmp);
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
			
			
			addChild( GameWorld.instance );
			addChild(CenterViewLayer.instance);
			addChild(PopUpManager.instance);
			
			GameWorld.instance.showBuildings();
			GameData.villageMode = VillageMode.NORMAL ;
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE , activateHandler);
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE , deactivateHandler );
		}
		
		private function activateHandler( e:flash.events.Event ):void 
		{
			if(GameData.villageMode!=VillageMode.VISIT)
			{
				GameData.commDate = new Date();
				GameWorld.instance.buildingScene.refreshBuildingStatus();
			}
		}
		
		private function deactivateHandler( e:flash.events.Event ):void 
		{
			if(GameData.villageMode!=VillageMode.VISIT)
			{
				GameWorld.instance.buildingScene.readySave();
				_villageUtil.saveVillage();
			}
		}
		
	}
}