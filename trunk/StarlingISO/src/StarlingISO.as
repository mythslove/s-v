package
{
	import bing.res.ResLoadedEvent;
	import bing.res.ResProgressEvent;
	import bing.res.ResVO;
	
	import com.greensock.plugins.BezierPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.desktop.NativeApplication;
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import local.MainGame;
	import local.comm.GameSetting;
	import local.model.*;
	import local.util.ResourceUtil;
	import local.vo.*;
	
	import starling.core.Starling;
	
	public class StarlingISO extends Sprite
	{
		[Embed(source="Default-Landscape.png")]
		private const  IPAD_LOADING:Class ;
		[Embed(source="Default.png")]
		private const  IPHONE_LOADING:Class ;
		
		private var _starling:Starling ;
		private var _loading:Bitmap;
		
		public function StarlingISO()
		{
			super();
			stage.frameRate=60;
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.color = 0 ;
			stage.mouseChildren = false ;
			NativeApplication.nativeApplication.executeInBackground = true ;
			
			if(stage.fullScreenWidth % 1024==0){
				_loading = new IPAD_LOADING() as Bitmap;
				_loading.width = stage.fullScreenWidth ;
				_loading.height = stage.fullScreenHeight ;
			}else{ // if(stage.fullScreenWidth % 480==0){
				_loading = new IPHONE_LOADING() as Bitmap;
				_loading.height = stage.fullScreenWidth ;
				_loading.width = stage.fullScreenHeight ;
				_loading.rotation= -90;
				_loading.y = _loading.height;
			}
			addChild(_loading);
			
			TweenPlugin.activate([BezierPlugin]);
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
			ShopModel.instance.allBuildingHash = bytes.readObject() as Dictionary ;
			ShopModel.instance.baseBuildings = bytes.readObject() as Vector.<BaseBuildingVO> ;
			LandModel.instance.expands = bytes.readObject() as Vector.<ExpandVO>;
			PlayerModel.instance.levels =  bytes.readObject() as Dictionary ;
			CompsModel.instance.allComps = bytes.readObject() as Dictionary ;
			QuestModel.instance.allQuestArray = bytes.readObject() as Vector.<QuestVO>  ;
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
		
		private function initGame():void
		{
			ShopModel.instance.initShopData();
			
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = true; // not necessary on iOS. Saves a lot of memory!
			
			_starling = new Starling( MainGame , stage , new Rectangle(0,0,stage.fullScreenWidth,stage.fullScreenHeight) ,  null, "auto", "baseline" );
			_starling.showStats = true ;
			_starling.antiAliasing = 0 ;
			_starling.enableErrorChecking = false ;
			
			if(stage.fullScreenWidth%1024==0){
				//ipad1,2,3
				GameSetting.isIpad = true ;
				GameSetting.SCREEN_WIDTH = _starling.stage.stageWidth = 1024;
				GameSetting.SCREEN_HEIGHT =_starling.stage.stageHeight  = 768 ;
			}else if( stage.fullScreenWidth % 1136==0 ){
				//iphone5
				GameSetting.SCREEN_WIDTH = _starling.stage.stageWidth = 960;
				GameSetting.SCREEN_HEIGHT =_starling.stage.stageHeight  = 640 ;
				_starling.stage.x = (1136-960)>>1 ;
			}else if( stage.fullScreenWidth % 480==0 ){
				//iphone4,4s,3GS
				GameSetting.SCREEN_WIDTH = _starling.stage.stageWidth = 960;
				GameSetting.SCREEN_HEIGHT = _starling.stage.stageHeight  = 640 ;
			}else{
				GameSetting.SCREEN_WIDTH = _starling.stage.stageWidth = stage.fullScreenWidth;
				GameSetting.SCREEN_HEIGHT = _starling.stage.stageHeight  = stage.fullScreenHeight ;
			}
			_starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE , contextCreatedHandler );
		}
		
		private function contextCreatedHandler( e:Event):void
		{
			_starling.stage3D.removeEventListener(Event.CONTEXT3D_CREATE , contextCreatedHandler );
			_starling.start() ;
			//移除loading
			removeChild(_loading);
			_loading.bitmapData.dispose();
			_loading = null ;
		}
		
	}
}