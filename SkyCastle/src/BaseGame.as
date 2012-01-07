package
{
	import bing.res.ResLoadedEvent;
	import bing.res.ResProgressEvent;
	import bing.res.ResVO;
	
	import comm.GameSetting;
	import comm.GlobalDispatcher;
	import comm.GlobalEvent;
	
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	
	import utils.ResourceUtil;
	
	/**
	 * 游戏入口基类 
	 * @author zzhanglin
	 */	
	public class BaseGame extends Sprite
	{
		private var _preLoading:SWC_preLoad ;
		
		/**
		 * 构造函数 
		 */		
		public function BaseGame()
		{
			super();
			stage.align="TL";
			stage.scaleMode = "noScale";
			stage.quality = StageQuality.MEDIUM;
			stage.addEventListener(Event.RESIZE , onResizeHandler);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN , onResizeHandler);
			
			init();
			addLoading();
			initLoad();
		}
		
		/**
		 * 获取游戏的一些参数和变量 
		 */		
		private function init():void
		{
			
		}
		
		/**
		 * 窗口大小变化 
		 * @param e
		 */		
		private function onResizeHandler(e:Event):void
		{
			e.stopPropagation();
			GlobalDispatcher.instance.dispatchEvent( new GlobalEvent(GlobalEvent.RESIZE));
		}
		
		/**
		 * 添加进度条 
		 */		
		private function addLoading():void
		{
			_preLoading = new SWC_preLoad();
			_preLoading.x = (GameSetting.SCREEN_WIDTH-_preLoading.width)>>1;
			_preLoading.y = (GameSetting.SCREEN_HEIGHT-_preLoading.height)>>1;
			addChild( _preLoading );
		}
		
		/**
		 * 下载游戏开始前的资源 
		 */		
		private function initLoad():void
		{
			var res:Vector.<ResVO> = new Vector.<ResVO>();
			res.push( new ResVO("config","res/config.xml"));
			res.push( new ResVO("bg","res/skin/bg.swf"));
			ResourceUtil.instance.addEventListener(ResProgressEvent.RES_LOAD_PROGRESS , queueLoadHandler);
			ResourceUtil.instance.addEventListener(ResLoadedEvent.QUEUE_LOADED ,queueLoadHandler);
			ResourceUtil.instance.queueLoad( res , 5 );
		}
		
		/**
		 * 序列下载资源完成 
		 * @param e
		 */		
		private function queueLoadHandler( e:Event):void
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
					removeLoading();
					inited();
					break;
			}
		}
		
		/**
		 * 解析config.xml
		 */		
		private function parseConfig():void
		{
			
		}
		
		/**
		 * 删除进度条 
		 */		
		private function removeLoading():void
		{
			removeChild(_preLoading);
			_preLoading = null ;
		}
		
		/**
		 * 子类重写 
		 */		
		protected function inited():void
		{
			
		}
	}
}