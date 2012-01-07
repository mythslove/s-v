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
	
	public class BaseGame extends Sprite
	{
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
		
		private function init():void
		{
			
		}
		
		private function onResizeHandler(e:Event):void
		{
			e.stopPropagation();
			GameSetting.SCREEN_WIDTH = stage.stageWidth;
			GameSetting.SCREEN_HEIGHT = stage.stageHeight ;
			GlobalDispatcher.instance.dispatchEvent( new GlobalEvent(GlobalEvent.RESIZE));
		}
		
		private function addLoading():void
		{
			
		}
		
		private function initLoad():void
		{
			var res:Vector.<ResVO> = new Vector.<ResVO>();
			res.push( new ResVO("config","res/config.xml"));
			res.push( new ResVO("bg","res/skin/bg.swf"));
			ResourceUtil.instance.addEventListener(ResProgressEvent.RES_LOAD_PROGRESS , queueLoadHandler);
			ResourceUtil.instance.addEventListener(ResLoadedEvent.QUEUE_LOADED ,queueLoadHandler);
			ResourceUtil.instance.queueLoad( res , 5 );
		}
		
		private function queueLoadHandler( e:Event):void
		{
			switch( e.type)
			{
				case ResProgressEvent.RES_LOAD_PROGRESS:
					break;
				case ResLoadedEvent.QUEUE_LOADED:
					ResourceUtil.instance.removeEventListener(ResProgressEvent.RES_LOAD_PROGRESS , queueLoadHandler);
					ResourceUtil.instance.removeEventListener(ResLoadedEvent.QUEUE_LOADED ,queueLoadHandler);
					
					removeLoading();
					inited();
					break;
			}
		}
		
		private function removeLoading():void
		{
			
		}
		
		/**
		 * 子类重写 
		 */		
		protected function inited():void
		{
			
		}
	}
}