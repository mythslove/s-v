package
{
	import com.greensock.plugins.BezierPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.desktop.NativeApplication;
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import local.MainGame;
	import local.comm.GameSetting;
	
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
//			registerVO();
//			loadConfig();
		}
		
		private function initGame():void
		{
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = true; // not necessary on iOS. Saves a lot of memory!
			
			_starling = new Starling( MainGame , stage , new Rectangle(0,0,stage.fullScreenWidth,stage.fullScreenHeight) ,  null, "auto", "baseline" );
			_starling.showStats = true ;
			_starling.antiAliasing = 0 ;
			_starling.enableErrorChecking = false ;
			
			if(stage.fullScreenWidth%2048==0){
				//ipad3
				GameSetting.SCREEN_WIDTH = _starling.stage.stageWidth = 1024;
				GameSetting.SCREEN_HEIGHT =_starling.stage.stageHeight  = 768 ;
			}
			else if( stage.fullScreenWidth%960==0)
			{
				GameSetting.SCREEN_WIDTH = _starling.stage.stageWidth = 960;
				GameSetting.SCREEN_HEIGHT = _starling.stage.stageHeight  = 640 ;
			}
			else
			{
				GameSetting.SCREEN_WIDTH = _starling.stage.stageWidth = 960;
				GameSetting.SCREEN_HEIGHT = _starling.stage.stageHeight  = 640 ;
				var view:Rectangle = new Rectangle(0,0,960,640) ;
				view.x = (stage.fullScreenWidth-view.x )>>1 ;
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