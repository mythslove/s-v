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
	import local.model.ShopModel;
	import local.util.EmbedManager;
	import local.util.ResourceUtil;
	import local.vo.*;
	
	import starling.core.Starling;
	
	public class Restaurant extends Sprite
	{
		[Embed(source="Default-Landscape.png")]
		private const  IPAD_LOADING:Class ;
		[Embed(source="Default.png")]
		private const  IPHONE_LOADING:Class ;
		
		private var _starling:Starling ;
		private var _loading:Bitmap;
		
		public function Restaurant()
		{
			super();
			stage.frameRate=60;
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.color = 0 ;
			stage.mouseChildren = false ;
			NativeApplication.nativeApplication.executeInBackground = true ;
			
			//判断是加载高清资源还是低清资源
			if(stage.fullScreenWidth % 1024==0){
				_loading = new IPAD_LOADING() as Bitmap;
				_loading.width = stage.fullScreenWidth ;
				_loading.height = stage.fullScreenHeight ;
			}else{
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
		
		
		private function registerVO():void
		{
			registerClassAlias( "PlayerVO",PlayerVO );
			registerClassAlias( "BaseItemVO",BaseItemVO );
			registerClassAlias( "FoodVO",FoodVO );
		}
		
		private function loadConfig():void
		{
			ResourceUtil.instance.addEventListener("GameConfig" , gameConfigHandler );
			ResourceUtil.instance.loadRes( new ResVO("GameConfig" , "config/config.bin") );
		}
		
		
		private function gameConfigHandler( e:ResLoadedEvent ):void
		{
			ResourceUtil.instance.removeEventListener("GameConfig" , gameConfigHandler );
			var bytes:ByteArray = e.resVO.resObject as ByteArray ;
			
			ShopModel.instance.allItemsHash = bytes.readObject() as Dictionary;
			ShopModel.instance.baseItems = bytes.readObject() as Vector.<BaseItemVO> ;
			
			ResourceUtil.instance.deleteRes( "GameConfig");
			loadRes();
		}
		
		/*加载初始资源*/
		private function loadRes():void
		{
			var resVOs:Array = [] ;
			var allItemsHash:Dictionary = ShopModel.instance.allItemsHash ;
			if( allItemsHash){
				var baseVO:BaseItemVO ;
				for ( var name:String in allItemsHash){
					baseVO =  allItemsHash[name] as BaseItemVO ;
					if(baseVO.directions==4){
						resVOs.push( new ResVO(name+"_1" , baseVO.getDirectionUrl(1 ))  ) ;
						resVOs.push( new ResVO(name+"_2" , baseVO.getDirectionUrl(2 ))  ) ;
					} else{
						resVOs.push( new ResVO(name , baseVO.url ) ) ;
					}
				}
			}
			resVOs.push( new ResVO("game_map_png","map/BG_ROAD.png"));
			resVOs.push( new ResVO("game_map_xml","map/BG_ROAD.xml"));
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
//					EmbedManager.ui_png = ResourceUtil.instance.getResVOByResId("game_ui_png").resObject as Bitmap;
//					EmbedManager.ui_xml = XML(ResourceUtil.instance.getResVOByResId("game_ui_xml").resObject);
					EmbedManager.map_png = ResourceUtil.instance.getResVOByResId("game_map_png").resObject as Bitmap;
					EmbedManager.map_xml = XML(ResourceUtil.instance.getResVOByResId("game_map_xml").resObject);
					
					initGame();
					break ;
			}
		}
		
		
		private function initGame():void
		{
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = true; // not necessary on iOS. Saves a lot of memory!
			
			_starling = new Starling( MainGame , stage , new Rectangle(0,0,stage.fullScreenWidth,stage.fullScreenHeight) ,  null, "auto", "baseline" );
			_starling.showStats = true ;
			_starling.antiAliasing = 0 ;
			_starling.enableErrorChecking = false ;
			
			if(stage.fullScreenWidth%1024==0){
				//ipad3
				GameSetting.SCREEN_WIDTH = _starling.stage.stageWidth = 1024;
				GameSetting.SCREEN_HEIGHT =_starling.stage.stageHeight  = 768 ;
			}
			else if( stage.fullScreenWidth%480==0)
			{
				GameSetting.SCREEN_WIDTH = _starling.stage.stageWidth = 960;
				GameSetting.SCREEN_HEIGHT = _starling.stage.stageHeight  = 640 ;
			}
			else 
			{
				GameSetting.SCREEN_WIDTH = _starling.stage.stageWidth = 960;
				GameSetting.SCREEN_HEIGHT = _starling.stage.stageHeight  = 640 ;
				var view:Rectangle = new Rectangle(0,0,960,640) ;
				view.x = (stage.fullScreenWidth-960 )>>1 ;
				_starling.viewPort = view ;
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