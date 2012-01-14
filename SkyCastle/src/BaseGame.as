package
{
	import bing.res.ResLoadedEvent;
	import bing.res.ResProgressEvent;
	import bing.res.ResVO;
	
	import comm.GameSetting;
	import comm.GlobalDispatcher;
	import comm.GlobalEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	
	import models.BuildingBaseModel;
	import models.ShopModel;
	
	import utils.ResourceUtil;
	
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
			stage.align="TL";
			stage.scaleMode = "noScale";
			stage.showDefaultContextMenu = false ;
			
			init();
			addLoading();
			initLoad();
		}
		
		/**
		 * 获取游戏的一些参数和变量 
		 */		
		protected function init():void
		{
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
			var res:Vector.<ResVO> = new Vector.<ResVO>();
			res.push( new ResVO("config","res/config.xml"));
			res.push( new ResVO("ui","res/skin/ui.swf"));
			res.push( new ResVO("bg","res/skin/bg.swf"));
			res.push( new ResVO("mapdata","res/mapdata") ); 
			ResourceUtil.instance.addEventListener(ResProgressEvent.RES_LOAD_PROGRESS , queueLoadHandler);
			ResourceUtil.instance.addEventListener(ResLoadedEvent.QUEUE_LOADED ,queueLoadHandler);
			ResourceUtil.instance.queueLoad( res , 5 );
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
				case ResLoadedEvent.QUEUE_LOADED:
					ResourceUtil.instance.removeEventListener(ResProgressEvent.RES_LOAD_PROGRESS , queueLoadHandler);
					ResourceUtil.instance.removeEventListener(ResLoadedEvent.QUEUE_LOADED ,queueLoadHandler);
					parseConfig();
					inited();
					removeLoading();
					break;
			}
		}
		
		/**
		 * 解析config.xml
		 */		
		protected function parseConfig():void
		{
			var config:XML = XML(ResourceUtil.instance.getResVOByResId("config").resObject.toString()) ;
			BuildingBaseModel.instance.parseConfig( config ) ;
			ShopModel.instance.parseConfig(config);
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
		}
	}
}