package
{
	import bing.res.ResLoadedEvent;
	import bing.res.ResProgressEvent;
	import bing.res.ResVO;
	import bing.utils.SystemUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.utils.ByteArray;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.comm.GlobalDispatcher;
	import local.comm.GlobalEvent;
	import local.game.GameWorld;
	import local.model.CollectionModel;
	import local.model.PickupModel;
	import local.model.ShopModel;
	import local.model.buildings.BaseBuildingVOModel;
	import local.model.vos.ConfigBaseVO;
	import local.utils.ResourceUtil;
	import local.views.CenterViewContainer;
	import local.views.LeftBar;
	import local.views.RightBar;
	
	/**
	 * 游戏入口基类 
	 * @author zzhanglin
	 */	
	public class BaseGame extends Sprite
	{
		protected var _preLoading:SWC_preLoad ;
		
		/**
		 * 构造函数 
		 */		
		public function BaseGame()
		{
			super();
			init();
			addLoading();
			initLoad();
		}
		
		/**
		 * 获取游戏的一些参数和变量 
		 */		
		protected function init():void
		{
			if( stage.loaderInfo.url.indexOf("http")==0 ){
				ResourceUtil.instance.isRemote = true ;
			}else{
				ResourceUtil.instance.isRemote = false ;
			}
		}
		
		/**
		 * 添加进度条 
		 */		
		protected function addLoading():void
		{
			_preLoading = new SWC_preLoad();
			_preLoading.x = (GameSetting.SCREEN_WIDTH-_preLoading.width)>>1;
			_preLoading.y = (GameSetting.SCREEN_HEIGHT-_preLoading.height)>>1;
			addChild( _preLoading );
		}
		
		/**
		 * 下载游戏开始前的资源 
		 */		
		protected function initLoad():void
		{
			var res:Array = [] ;
			res.push( new ResVO("init_config","res/config.bin"));
			res.push( new ResVO(GameData.currentMapId+"_DATA","res/map/"+GameData.currentMapId+"_DATA.bin") ); 
			res.push( new ResVO(GameData.currentMapId+"_BUILDINGS","res/map/"+GameData.currentMapId+"_BUILDINGS.bin") ); 
			res.push( new ResVO(GameData.currentMapId+"_BACKGROUND","res/map/"+GameData.currentMapId+"_BACKGROUND.swf"));
			res.push( new ResVO("init_effect","res/skin/Effect.swf") );
			res.push( new ResVO("init_Popup","res/skin/Popup.swf") );
			res.push( new ResVO("init_ui","res/skin/ui.swf"));
			res.push( new ResVO("init_SoundsCore","res/skin/SoundsCore.swf") );
			res.push( new ResVO("Basic_Avatar","res/character/Basic_AvatarFemale.swf") );
			res.push( new ResVO("Basic_Bamboo","res/tree/Basic_Bamboo.swf") );
			res.push( new ResVO("Basic_Grass","res/tree/Basic_Grass.swf") );
			res.push( new ResVO("Basic_ruin","res/tree/Basic_ruin.swf") );
			res.push( new ResVO("Basic_PineTree","res/tree/Basic_PineTree.swf") );
			res.push( new ResVO("Basic_Rock","res/rock/Basic_Rock.swf") );
			res.push( new ResVO("Basic_Vine","res/rock/Basic_Vine.swf") );
			res.push( new ResVO("Basic_Stone","res/stone/Basic_Stone.swf") );
			
			ResourceUtil.instance.addEventListener(ResProgressEvent.RES_LOAD_PROGRESS , queueLoadHandler);
			ResourceUtil.instance.addEventListener("initUI" ,queueLoadHandler);
			ResourceUtil.instance.queueLoad( "initUI" , res , 5 );
		}
		
		/**
		 * 序列下载资源完成 
		 * @param e
		 */		
		protected function queueLoadHandler( e:Event):void
		{
			switch( e.type)
			{
				case ResProgressEvent.RES_LOAD_PROGRESS:
					var evt:ResProgressEvent = e as ResProgressEvent;
					_preLoading.loaderBar.gotoAndStop( (evt.loaded/evt.total*100 )>>0 );
					break;
				case "initUI":
					SystemUtil.debug("初始资源下载完成");
					ResourceUtil.instance.removeEventListener(ResProgressEvent.RES_LOAD_PROGRESS , queueLoadHandler);
					ResourceUtil.instance.removeEventListener("initUI" ,queueLoadHandler);
					
					addChild(GameWorld.instance); //添加游戏世界
					addChild( new LeftBar()); //居左的容器
					addChild( new RightBar()); //居右的容器
					addChild( CenterViewContainer.instance); //添加UI的容器
					addChild(_preLoading);
					
					parseConfig();
					inited();
					break;
			}
		}
		
		/**
		 * 解析config
		 */		
		protected function parseConfig():void
		{
			var bytes:ByteArray = ResourceUtil.instance.getResVOByResId("init_config").resObject as ByteArray ;
			try{
				bytes.uncompress();
			}catch(e:Error){
				SystemUtil.debug("config没有压缩");
			}
			var config:ConfigBaseVO = bytes.readObject() as ConfigBaseVO;
			if(config){
				//各自解析
				BaseBuildingVOModel.instance.parseConfig( config );
				ShopModel.instance.parseConfig( config );
				PickupModel.instance.parseConfig(config);
				CollectionModel.instance.parseConfig(config);
				
				GameData.config = config ;
			}else{
				throw new Error("配置文件解析失败");
			}
		}
		
		/**
		 * 删除进度条 
		 */		
		protected function removeLoading():void
		{
			removeChild(_preLoading);
			_preLoading = null ;
		}
		
		/**
		 * 子类重写 
		 */		
		protected function inited():void
		{
			stage.addEventListener(Event.RESIZE , onResizeHandler);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN , onResizeHandler);
			
			GameWorld.instance.init();
		}
		
		/**
		 * 窗口大小变化 
		 * @param e
		 */		
		protected function onResizeHandler(e:Event):void
		{
			e.stopPropagation();
			GlobalDispatcher.instance.dispatchEvent( new GlobalEvent(GlobalEvent.RESIZE));
		}
	}
}