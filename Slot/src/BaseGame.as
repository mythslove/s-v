package
{
	import bing.res.ResLoadedEvent;
	import bing.res.ResProgressEvent;
	import bing.res.ResVO;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.net.registerClassAlias;
	
	import game.comm.GlobalDispatcher;
	import game.comm.GlobalEvent;
	import game.models.SlotItemsModel;
	import game.models.vos.*;
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
			
			registerVOs();
//			addLoading();
			initLoad();
		}
		
		private function registerVOs():void
		{
			registerClassAlias( "game.models.vos.SlotItemVO", SlotItemVO);
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
			res.push( new ResVO("skin_room","res/rooms/Room_cn.swf"));
			res.push( new ResVO("skin_hallLogo","res/rooms/hallLogo.swf"));
			res.push( new ResVO("xml_config","res/config.xml"));
			ResourceUtil.instance.addEventListener(ResProgressEvent.RES_LOAD_PROGRESS , queueLoadHandler);
			ResourceUtil.instance.addEventListener(ResLoadedEvent.QUEUE_LOADED ,queueLoadHandler);
			ResourceUtil.instance.queueLoad( res , 5 );
		}
		
		protected function queueLoadHandler(e:Event):void
		{
			switch( e.type)
			{
				case ResProgressEvent.RES_LOAD_PROGRESS:
					var evt:ResProgressEvent = e as ResProgressEvent;
//					_preLoading.loaderBar.gotoAndStop( (evt.loaded/evt.total*100 )>>0 );
					break;
				case ResLoadedEvent.QUEUE_LOADED:
					ResourceUtil.instance.removeEventListener(ResProgressEvent.RES_LOAD_PROGRESS , queueLoadHandler);
					ResourceUtil.instance.removeEventListener(ResLoadedEvent.QUEUE_LOADED ,queueLoadHandler);
					parseConfig();
					inited();
//					removeLoading();
					break;
			}
		}
		
		protected function parseConfig():void
		{
			var config:XML = XML(ResourceUtil.instance.getResVOByResId("xml_config").resObject.toString()) ;
			SlotItemsModel.instance.parseConfig(config);
		}
		
		protected function inited():void
		{
			stage.addEventListener(Event.RESIZE , onResizeHandler);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN , onResizeHandler);
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