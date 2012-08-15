package game.init
{
	import bing.utils.SystemUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import game.events.GameInitEvent;
	import game.global.GameData;
	import game.mvc.model.AniBaseModel;
	import game.mvc.model.ItemVOModel;
	import game.mvc.model.MapDataModel;

	[Event(name="configXMLLoading",type="game.events.GameInitEvent")]
	[Event(name="configXMLLoaded",type="game.events.GameInitEvent")]
	public class ConfigXMLInit extends EventDispatcher
	{

		public var configXML:XML ;
		
		private var _urlLoader:URLLoader ;
		
		public function loadConfig():void
		{
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY ;
			_urlLoader.addEventListener(ProgressEvent.PROGRESS , loadProgressHandler );
			_urlLoader.addEventListener(Event.COMPLETE , loadCompleteHandler );
			_urlLoader.load( new URLRequest(GameData.baseURL+"config.xml") );
		}
		
		private function loadProgressHandler(e:ProgressEvent):void
		{
			var evt:GameInitEvent = new GameInitEvent( GameInitEvent.CONFIG_XML_LOADING ) ;
			evt.progress = e.bytesLoaded/e.bytesTotal ;
			this.dispatchEvent( evt );
		}
		
		private function loadCompleteHandler(e:Event):void
		{
			_urlLoader.removeEventListener(ProgressEvent.PROGRESS , loadProgressHandler );
			_urlLoader.removeEventListener(Event.COMPLETE , loadCompleteHandler );
			if(e.target.data)
			{
				var byteArray:ByteArray = e.target.data as ByteArray;
				try{
					byteArray.uncompress();	
				}catch(event:Error){
					SystemUtil.debug("没有压缩configXML");
				}finally{
					this.configXML = XML(byteArray.toString());
				}
			}
			_urlLoader = null ;
			this.dispatchEvent( new GameInitEvent( GameInitEvent.CONFIG_XML_LOADED ) );
		}
	}
}