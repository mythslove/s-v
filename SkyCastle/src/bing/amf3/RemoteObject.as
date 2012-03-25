package bing.amf3
{
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	 * 返回结果
	 */	
	[Event(name="amfResult",type="bing.amf3.ResultEvent")]
	/**
	 * 调用后台接口错误信息
	 */	
	[Event(name="amfFault",type="bing.amf3.FaultEvent")]
	/**
	 * AMF3，类似于flex的RemoteObject
	 * @author zhouzhanglin
	 */	
	dynamic public class RemoteObject extends Proxy implements IEventDispatcher
	{
		private var _nc:NetConnection;
		private var _servicePath:String ;
		private var _dispatcher:EventDispatcher ;
		/** 超时时间，单位毫秒，０为不设置超时*/
		public var timeout:int = 0 ; 
		
		public function RemoteObject( gateWay:String ,  servicePath:String )
		{
			_dispatcher = new EventDispatcher();
			_servicePath = servicePath ;
			_nc = new NetConnection();
			_nc.client = this ;
			
			_nc.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatus);
			_nc.addEventListener(IOErrorEvent.IO_ERROR, handleErrorEvent);
			_nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleErrorEvent);
			_nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, handleErrorEvent);
			_nc.connect( gateWay);
		}
		
		private function handleNetStatus(e:NetStatusEvent):void 
		{
			if(e.info.code!="NetConnection.Connect.Success")
			{
				dispatchFaultEvent("NetConnect","connect" , String(e.info.code)  );
			}
		}

		private function handleErrorEvent( event : Event ) : void 
		{
			dispatchFaultEvent("NetConnect","connect" , event.type+" error:" +event["text"]  );
		}
		
		private function onFault( rpc:PendingCall ):void
		{
			dispatchFaultEvent(rpc.service,rpc.method ,rpc.fault.message );
		}
		
		private function dispatchFaultEvent( service:String , method:String , message:String ):void 
		{
			var evt:FaultEvent = new FaultEvent( FaultEvent.FAULT );
			evt.faultObj = new Object();
			evt.faultObj.service = service ;
			evt.faultObj.method = method ;
			evt.faultObj.message =  message ;
			this.dispatchEvent( evt );
		}
		
		private function onResult( rpc:PendingCall ):void
		{
			var evt:ResultEvent = new ResultEvent( ResultEvent.RESULT);
			evt.result = rpc.result ;
			evt.method = rpc.method;
			evt.service = rpc.service;
			this.dispatchEvent( evt);
		}
		
		/**
		 * 用于AMF通讯
		 * 覆盖对象的callProperty方法
		 */
		override flash_proxy function callProperty(methodName:*, ...parametres:*):*
		{
			var rpc:PendingCall = new PendingCall(_nc,_servicePath,methodName, onResult , onFault , parametres , timeout );
			rpc.execute();
		}
		
		/**
		 * 用于AMF
		 * 获得操作，通过send发送信息
		 * @param methodName 方法名
		 * @return 
		 */		
		public function getOperation( methodName:String ):PendingCall
		{
			return new PendingCall(_nc,_servicePath,methodName, onResult , onFault,null,timeout);
		}
		
		/**
		 * 通过URLLoader的POST通讯
		 * @param methodName
		 * @param getWay
		 * @return 
		 */		
		public function getHttpOperation( methodName:String , getWay:String = null ):HttpCall
		{
			if(!getWay) getWay = _servicePath;
			return new HttpCall(getWay,methodName, onResult , onFault,null,timeout);
		}
		
		/**
		 * 覆盖对象的getProperty方法
		 */
		override flash_proxy function getProperty(name : *) : * {
			return undefined;
		}
		
		
		/**
		 * 覆盖对象的hasProperty方法
		 */
		
		override flash_proxy function hasProperty(name : *) : Boolean {
			
			return false;
		}
		
		/**
		 * 描述
		 */
		public function toString( ) : String {
			
			return "[object RemoteObject]";
		}
		
		
		/**
		 * 实现 IEventDispatcher 接口
		 */
		
		public function addEventListener( type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false ) : void {
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent( event : Event ) : Boolean {
			return _dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener( type : String ) : Boolean {
			return _dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener( type : String, listener : Function, useCapture : Boolean = false ) : void {
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger( type : String ) : Boolean {
			return _dispatcher.willTrigger(type);
		}
		
		public function dispose():void 
		{
			_nc.removeEventListener(NetStatusEvent.NET_STATUS, handleNetStatus);
			_nc.removeEventListener(IOErrorEvent.IO_ERROR, handleErrorEvent);
			_nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleErrorEvent);
			_nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, handleErrorEvent);
		}
	}
}