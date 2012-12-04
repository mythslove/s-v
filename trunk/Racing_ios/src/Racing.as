package
{
	import bing.res.ResPool;
	import bing.res.ResProgressEvent;
	import bing.res.ResType;
	import bing.res.ResVO;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	import flash.system.Capabilities;
	
	import game.StarlingAppliaction;
	import game.comm.GameSetting;
	import game.model.CarModel;
	import game.model.TrackModel;
	import game.vos.*;
	
	import starling.core.Starling;
	
	public class Racing extends Sprite
	{
		private var _starling:Starling ;
		
		public function Racing()
		{
			super();
			
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60 ;
			
			if(Capabilities.os.toLowerCase().indexOf("windows")==-1){
				GameSetting.TEXTURE_TYPE=".atf";
			}
			
			//添加loading
			registerVO();
			loadRes();
		}
		
		private function registerVO():void
		{
			registerClassAlias("CarVO",CarVO);
			registerClassAlias("PlayCarVO",PlayerCarVO);
			registerClassAlias("CarParamVO",CarParamVO);
		}
		
		private function loadRes():void
		{
			ResPool.instance.cdns=Vector.<String>(["res/"]);
			ResPool.instance.isRemote = false ;
			ResPool.instance.maxLoadNum = 4 ;
			var resVOs:Array=[];
			resVOs.push( new ResVO("Config_Car","config/Config_Car.xml"));
			resVOs.push( new ResVO("Config_Track","config/Config_Track.xml"));
			var vo:ResVO = new ResVO("DustParticle_PEX","effects/particle.pex") ;
			vo.resType = ResType.TEXT ;
			resVOs.push( vo );
			ResPool.instance.addEventListener(ResProgressEvent.RES_LOAD_PROGRESS , resLoadHandler );
			ResPool.instance.addEventListener("loadConfig" , resLoadHandler );
			ResPool.instance.queueLoad( "loadConfig",resVOs,3);
		}
		
		private function resLoadHandler(e:Event):void
		{
			switch(e.type)
			{
				case ResProgressEvent.RES_LOAD_PROGRESS:
					var evt:ResProgressEvent = e as ResProgressEvent ;
					trace(evt.loaded/evt.total*100+"%");
					break ;
				case "loadConfig":
					ResPool.instance.removeEventListener(ResProgressEvent.RES_LOAD_PROGRESS , resLoadHandler );
					ResPool.instance.removeEventListener("loadConfig" , resLoadHandler );
					CarModel.instance.parseConfig( ResPool.instance.getResVOByResId("Config_Car"));
					TrackModel.instance.parseConfig( ResPool.instance.getResVOByResId("Config_Track"));
					ResPool.instance.deleteRes("Config_Car");
					ResPool.instance.deleteRes("Config_Track");
					init();
					break ;
			}
		}
		
		
		
		private function init():void
		{
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = true; // not necessary on iOS. Saves a lot of memory!
			
			_starling = new Starling( StarlingAppliaction, stage , new Rectangle(0,0,stage.fullScreenWidth,stage.fullScreenHeight) ,null , "auto", "baseline" );
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
			_starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE , contextCreatedHandler );
		}
		
		private function contextCreatedHandler( e:Event):void
		{
			_starling.stage3D.removeEventListener(Event.CONTEXT3D_CREATE , contextCreatedHandler );
			_starling.start() ;
			//移除loading
		}
	}
}