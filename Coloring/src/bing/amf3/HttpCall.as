package bing.amf3
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class HttpCall
	{
		internal var service:String ; //服务名
		internal var method:String ; //方法名
		internal var params:Object ; //参数列表
		internal var result:Object; //结果
		internal var fault:Object ; //错误信息
		private var _timeout:int ;
		private var _timeoutId:int ;
		private var _onResult:Function ;
		private var _onFault:Function;
		private var _urlLoader:URLLoader;
		
		public function HttpCall( service:String , method:String, onResult:Function ,onFault:Function , params:URLVariables=null, timeout:int = 0)
		{
			this.service = service ;
			this.method = method;
			this.params = params ;
			this._onFault = onFault;
			this._onResult=onResult ;
			this._timeout = timeout;
		}
		
		internal function execute() : void 
		{
			_urlLoader = new URLLoader();
			var urlRequest:URLRequest= new URLRequest();
			urlRequest.method=URLRequestMethod.POST;
			urlRequest.data = params ;
			_urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			_urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, errorHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_urlLoader.load( urlRequest );
			
			if(_timeout>0){
				_timeoutId = setTimeout(handleTimeout , _timeout ) ;
			}
		} 
		
		private function completeHandler(e:Event):void
		{
			clearTimeout( _timeoutId );
			this.result = _urlLoader.data ;
			_onResult(this);
			removeListeners();
		}
		
		private function errorHandler(e:Event):void
		{
			switch(e.type)
			{
				case SecurityErrorEvent.SECURITY_ERROR:
					this.fault =(e as SecurityErrorEvent).text ;
					break;
				case HTTPStatusEvent.HTTP_STATUS:
					this.fault =(e as HTTPStatusEvent).status ;
					break ;
				case IOErrorEvent.IO_ERROR:
					this.fault = (e as IOErrorEvent).text ;
					break ;
			}
			clearTimeout( _timeoutId );
			_onFault(this);
			removeListeners();
		}
		
		private function removeListeners():void
		{
			_urlLoader.removeEventListener(Event.COMPLETE, completeHandler);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			_urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, errorHandler);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		}
		
		private function handleTimeout():void 
		{
			this.fault = new Object();
			this.fault.message = "调用接口超时";
			_onFault(this);
		}
		
		/**
		 * 发送信息 
		 * @param param URLVariable
		 */		
		public function send( ...param):void 
		{
			this.params = param ;
			execute();
		}
	}
}