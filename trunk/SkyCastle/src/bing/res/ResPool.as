package bing.res
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 资源加载错误
	 */	
	[Event(name="ioError",type="flash.events.IOErrorEvent")]
	/**
	 * 序列加载的资源，加载的进度
	 */	
	[Event(name="resLoadProgress",type="bing.res.ResProgressEvent")]
	/**
	 * 序列加载的资源，加载完成事件 
	 */	
	[Event(name="queueLoaded",type="bing.res.ResLoadedEvent")]
	public class ResPool extends EventDispatcher
	{
		protected static var _instance:ResPool; 
		protected var _resDictionary:Dictionary ;
		protected var _loadList:Vector.<ResVO> ;
		public var cdns:Vector.<String>;
		public var maxLoadNum:int = 4 ;//最大的下载数
		protected var _currentLoadNum:int = 0 ;
		
		public function ResPool()
		{
			if(_instance){
				throw new Error("重复实例化");
			}
			init();
		}
		
		public static function get instance():ResPool
		{
			if(!_instance) _instance = new ResPool();
			return _instance ;
		}
		
		protected function init():void
		{
			_resDictionary = new Dictionary(true);
			_loadList = new Vector.<ResVO>();
			cdns=new Vector.<String>() ;
			_currentLoadNum = 0 ;
		}
		
		/**
		 * 下载资源 
		 * @param resVO
		 */		
		public function loadRes( resVO:ResVO ):void 
		{
			if(!checkRes( resVO.resId ))
			{
				if( !resVO.resType ) setResType(resVO);
				_resDictionary[resVO.resId] = resVO ;
				if(_currentLoadNum<maxLoadNum)
				{
					loadAResource( resVO ); //下载资源
				}else{
					_loadList.push( resVO );
					_loadList.sort( compareLoadList );
				}
			}
		}
		
		//设置资源文件的类型
		protected function setResType( resVO:ResVO ):void
		{
			var extender:String=  resVO.url.substring( resVO.url.lastIndexOf(".")+1).toLocaleLowerCase();
			resVO.extension = extender ;
			switch( extender)
			{
				case "txt":
				case "xml":
				case "ini":
					resVO.resType = ResType.TEXT;
					break ;
				case "swf":
					resVO.resType = ResType.SWF;
					break ;
				case "png":
				case "jpg":
				case "jpeg":
				case "bmp":
					resVO.resType = ResType.IMG;
					break ;
				default:
					resVO.resType = ResType.BINARY ;
					break ;
			}
		}
		
		/**
		 * 下载一个资源 
		 * @param resVO
		 */		
		protected function loadAResource( resVO:ResVO ):void
		{
			switch(resVO.resType)
			{
				case ResType.TEXT:
				case ResType.BINARY:
					urlLoaderARes( resVO );
					break ;
				default:
					loaderARes(resVO);
					break ;
			}
		}
		protected function loaderARes(resVO:ResVO):void
		{
			var context:LoaderContext = new LoaderContext(false , ApplicationDomain.currentDomain);
			var loader:Loader = new Loader();
			loader.name = resVO.resId ;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE , loaderHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR , ioErrorHandler );
			var url:String = cdns[resVO.loadError]+resVO.url ;
			if(url.indexOf("http")==0 || url.indexOf("www.")==0 ){
				context.securityDomain = SecurityDomain.currentDomain;
			}
			loader.load( new URLRequest(url) ,context);
			_currentLoadNum++;
		}
		protected function urlLoaderARes(resVO:ResVO):void
		{
			var urlLoader:ResURLLoader = new ResURLLoader();
			urlLoader.name = resVO.resId ;
			if(resVO.resType==ResType.BINARY){
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			}
			urlLoader.addEventListener(Event.COMPLETE , urlLoaderHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR , ioErrorHandler );
			urlLoader.load( new URLRequest( cdns[resVO.loadError]+resVO.url  ) );
		}
		protected function loaderHandler(e:Event):void 
		{
			e.stopPropagation();
			var resLoader:Loader = e.target.loader as Loader;
			resLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE , loaderHandler );
			resLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR , ioErrorHandler );
			var resVO:ResVO = _resDictionary[resLoader.name] as ResVO ;
			handleRes(resVO , resLoader );
			//抛出资源加载完成事件
			var resLoadedEvent:ResLoadedEvent = new ResLoadedEvent(resVO.resId);
			resLoadedEvent.resVO = resVO ;
			this.dispatchEvent( resLoadedEvent );
			_currentLoadNum--;
			if( _loadList.length>0 ){ 	//下载下一个
				resVO = _loadList.shift() ;
				loadAResource( resVO );
			}
		}
		
		protected function urlLoaderHandler(e:Event):void
		{
			e.stopPropagation();
			var urlLoader:ResURLLoader = e.target as ResURLLoader ;
			urlLoader.removeEventListener(Event.COMPLETE , urlLoaderHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR , ioErrorHandler );
			var resVO:ResVO = _resDictionary[urlLoader.name] as ResVO ;
			handleRes(resVO , urlLoader.data );
			//抛出资源加载完成事件
			var resLoadedEvent:ResLoadedEvent = new ResLoadedEvent(resVO.resId);
			resLoadedEvent.resVO = resVO ;
			this.dispatchEvent( resLoadedEvent );
			_currentLoadNum--;
			//下载下一个
			if( _loadList.length>0 )
			{
				resVO = _loadList.shift() ;
				loadAResource( resVO );
			}
		}
		
		protected function compareLoadList( resVO1:ResVO , resVO2:ResVO ):int
		{
			return resVO2.priority-resVO1.priority ;
		}
		
		/**
		 * 处理下载后的资源 
		 * @param resVO
		 * @param resLoader
		 */		
		protected function handleRes(resVO:ResVO , resLoader:Object ):void 
		{
			switch(resVO.resType)
			{
				case ResType.TEXT :
				case ResType.BINARY :
					resVO.resObject = resLoader ;
					break ;
				case ResType.SWF :
					resVO.resObject = resLoader ;
					break ;
				case ResType.IMG :
					resVO.resObject = resLoader.contentLoaderInfo.content as Bitmap ;
					resLoader.unloadAndStop();
					break ;
			}
		}
		
		protected function ioErrorHandler(e:IOErrorEvent):void 
		{
			var resVO:ResVO  ;
			if(e.target is ResURLLoader){
				var urlLoader:ResURLLoader = e.target as ResURLLoader ;
				resVO = this.getResVOByResId( urlLoader.name );
				urlLoader.removeEventListener(Event.COMPLETE , urlLoaderHandler);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR , ioErrorHandler );
			}else{
				var resLoader:Loader = e.target.loader as Loader;
				resVO = this.getResVOByResId( resLoader.name );
				resLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE , loaderHandler );
				resLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR , ioErrorHandler );
			}
			_currentLoadNum--;
			if(resVO){
				this.deleteRes( resVO.resId );
				if(resVO.loadError<cdns.length-1){
					resVO.loadError++;
					this.loadAResource( resVO );
				}
				else
				{
					this.dispatchEvent( e );
					if(resVO.isQueue){ //如果是序列加载，并且加载失败，则跳过此资源
						resObjectLoadedHandler(null);
					}
				}
			}
		}
		
		/**
		 * 判断资源是否下载完成  
		 * @param resId 资源唯一标识 
		 * @return 
		 */		
		protected function checkRes( resId:String ):Boolean
		{
			if(_resDictionary[resId])
			{
				var resVO:ResVO = _resDictionary[resId] as ResVO;
				if(resVO.resObject)
				{
					var resLoadedEvent:ResLoadedEvent = new ResLoadedEvent(resId);
					resLoadedEvent.resVO = resVO ;
					this.dispatchEvent( resLoadedEvent );
				}
				return true;
			}
			return false;
		}
		
		
		/**
		 *  删除资源
		 * @param resId
		 */		
		public function deleteRes( resId:String ):void
		{
			if(_resDictionary[resId])
			{
				var resVO:ResVO = _resDictionary[resId] as ResVO;
				resVO.dispose();
				delete _resDictionary[resId] ;
			}
		}
		
		
		/**
		 * 通过resId, 获取已经下载的ResVO
		 * @param resId
		 * @return 
		 */	
		public function getResVOByResId( resId:String):ResVO
		{
			return _resDictionary[resId] as ResVO ;
		}
		
		/**
		 *  反射对象
		 * @param resId 资源的唯一标识值
		 * @param clsName 要反射的类名
		 * @return 
		 */		
		public function getInstanceByClassName( resId:String , clsName:String ):Object
		{
			var resVO:ResVO = getResVOByResId(resId);
			var obj:Object= null ;
			if(resVO && resVO.resObject )
			{
				try{
					obj = new (getDefinitionByName(clsName) as Class)();
				}catch(e:Error){}
			}
			return obj ;
		}
		
		
		//======================================================
		//=========加载多个资源====================================
		//======================================================
		
		protected  var _resArray:Vector.<ResVO>;
		protected var _queueHash :Dictionary ;
		protected var _queueLoaded:int ;
		protected var _total:int ;
		
		/**
		 * 加载多个 
		 * @param resArray [{name:"nam" , url:"role/aa.swf" , baseURL:baseURL}]
		 * @param maxNum 最多一次能开几个加载进程
		 */		
		public function queueLoad( resArray:Vector.<ResVO>, maxNum:int =2 ):void
		{
			_resArray = resArray ;
			_queueHash = new Dictionary(true) ;
			_total= resArray.length ;
			_queueLoaded = 0;
			for( var i:int=0 ; i<maxNum && i<_total ; ++i){
				startQueueLoad();
			}
		}
		
		protected function startQueueLoad():void
		{
			var content:ResVO = _resArray.shift();
			content.isQueue = true ;
			this._queueHash[content.resId] = content;
			this.addEventListener( content.resId , resObjectLoadedHandler );
			this.loadRes( content );
		}
		protected function resObjectLoadedHandler(e:Event):void
		{
			_queueLoaded ++;
			var evtLoadedEvt:ResLoadedEvent
			if(e){
				evtLoadedEvt = (e as ResLoadedEvent);
				this.removeEventListener( evtLoadedEvt.resVO.resId , resObjectLoadedHandler );
			}
			//加载进度
			var evt:ResProgressEvent = new ResProgressEvent(ResProgressEvent.RES_LOAD_PROGRESS);
			evt.total = _total ;
			evt.loaded = _queueLoaded ;
			if(evtLoadedEvt){
				evt.name = evtLoadedEvt.resVO.resId ;
			}
			this.dispatchEvent( evt );
			//判断是否还要加载
			if(_resArray.length>0){
				startQueueLoad();
			}else if(_queueLoaded==_total){
				_resArray = null ;
				_queueHash = null ;
				this.dispatchEvent(new ResLoadedEvent(ResLoadedEvent.QUEUE_LOADED));
			}
		}
		
		//==================dispose==================
		
		/**
		 * 清除缓存 
		 */		
		public function clearPool():void 
		{
			for each( var resVO:ResVO in _resDictionary)
			{
				resVO.dispose();
			}
			_resDictionary = new Dictionary();
			_loadList = new Vector.<ResVO>();
			_currentLoadNum = 0 ;
		}
	}
}