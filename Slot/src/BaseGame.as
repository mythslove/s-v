package
{
	import bing.res.ResLoadedEvent;
	import bing.res.ResProgressEvent;
	import bing.res.ResVO;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import game.utils.ResourceUtil;
	
	public class BaseGame extends Sprite
	{
//		protected var _preLoading:SWC_preLoad ;
		
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
		 * 添加进度条 
		 */		
		protected function addLoading():void
		{
//			_preLoading = new SWC_preLoad();
//			_preLoading.x = (GameSetting.SCREEN_WIDTH-_preLoading.width)>>1;
//			_preLoading.y = (GameSetting.SCREEN_HEIGHT-_preLoading.height)>>1;
//			addChild( _preLoading );
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
		
		protected function queueLoadHandler(e:Event):void
		{
			
		}
	}
}