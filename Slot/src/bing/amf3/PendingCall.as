package bing.amf3
{
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	/**
	 * 操作 
	 * @author zhouzhanglin
	 */	
	public class PendingCall
	{
		internal var service:String ; //服务名
		internal var method:String ; //方法名
		internal var params:Array ; //参数列表
		internal var result:Object; //结果
		internal var fault:Object ; //错误信息
		private var _responder:Responder;
		private var _conn:NetConnection;
		private var _onResult:Function ;
		private var _onFault:Function;
		private var _timeout:int ;
		private var _timeoutId:int ;
		
		public function PendingCall(connect:NetConnection,  service:String , method:String, onResult:Function ,onFault:Function , params:Array=null, timeout:int = 0 )
		{
			this._conn = connect ;
			this.service = service ;
			this.method = method;
			this.params = params ;
			this._onFault = onFault;
			this._onResult=onResult ;
			this._timeout = timeout;
			_responder  = new Responder(handleResult, handleStatus);
		}
		
		private function handleResult( obj : Object ) : void 
		{
			clearTimeout( _timeoutId );
			this.result = obj ;
			_onResult(this);
		}
		
		private function handleStatus( obj : Object ) : void 
		{
			clearTimeout( _timeoutId );
			this.fault = obj;
			_onFault(this);
		}
		
		internal function execute() : void 
		{
			var array:Array = new Array(service+"."+method, _responder);
			
			_conn.call.apply(_conn, array.concat(params) );
			
			if(_timeout>0){
				_timeoutId = setTimeout(handleTimeout , _timeout ) ;
			}
		} 
		
		private function handleTimeout():void 
		{
			this.fault = new Object();
			this.fault.message = "调用接口超时";
			_onFault(this);
		}
		
		/**
		 * 发送信息 
		 * @param param
		 */		
		public function send( ...param):void 
		{
			this.params = param ;
			execute();
		}
	}
}