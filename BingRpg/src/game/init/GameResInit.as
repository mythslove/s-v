package game.init
{
	import bing.res.ResLoadedEvent;
	import bing.res.ResProgressEvent;
	import bing.res.ResVO;
	import bing.utils.SystemUtil;
	
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	
	import game.events.GameInitEvent;
	import game.global.GameData;
	import game.utils.GameResourePool;

	/**
	 * 游戏初始化资源加载 
	 * @author zhouzhanglin
	 */	
	[Event(name="uiSwfLoaded",type="game.events.GameInitEvent")]
	[Event(name="uiSwfLoading",type="game.events.GameInitEvent")]
	public class GameResInit extends EventDispatcher
	{
		
		public function loadInitRes():void 
		{
			var res:Vector.<ResVO> = new Vector.<ResVO>() ;
			res.push(new ResVO("skinViews","skin/Views.swf") );
			GameResourePool.instance.addEventListener(ResLoadedEvent.QUEUE_LOADED , initResLoadedHandler );
			GameResourePool.instance.addEventListener(ResProgressEvent.RES_LOAD_PROGRESS,initResLoadProgressHandler);
			GameResourePool.instance.addEventListener(IOErrorEvent.IO_ERROR ,initResLoadErrorHandler );
			GameResourePool.instance.queueLoad(res);
		}
		
		private function initResLoadErrorHandler(e:IOErrorEvent):void 
		{
			e.stopPropagation() ;
			GameResourePool.instance.removeEventListener(ResLoadedEvent.QUEUE_LOADED , initResLoadedHandler );
			GameResourePool.instance.removeEventListener(ResProgressEvent.RES_LOAD_PROGRESS,initResLoadProgressHandler);
			GameResourePool.instance.removeEventListener(IOErrorEvent.IO_ERROR ,initResLoadErrorHandler );
			SystemUtil.debug("初始资源下载错误", e.text );
		}
		
		private function initResLoadProgressHandler(e:ResProgressEvent):void
		{
			var evt:GameInitEvent = new GameInitEvent( GameInitEvent.UI_SWF_LOADING) ;
			evt.progress = e.loaded/e.total ;
			this.dispatchEvent( evt );
		}
		
		private function initResLoadedHandler( e:ResLoadedEvent ):void 
		{
			GameResourePool.instance.removeEventListener(ResLoadedEvent.QUEUE_LOADED , initResLoadedHandler );
			GameResourePool.instance.removeEventListener(ResProgressEvent.RES_LOAD_PROGRESS,initResLoadProgressHandler);
			GameResourePool.instance.removeEventListener(IOErrorEvent.IO_ERROR ,initResLoadErrorHandler );
			SystemUtil.debug("初始资源下载完成");
			this.dispatchEvent( new GameInitEvent( GameInitEvent.UI_SWF_LOADED) );
		}
	}
}