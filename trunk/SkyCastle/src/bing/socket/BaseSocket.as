package  bing.socket
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	/**
	 * socket处理类，作为基类用 
	 * @author zhouzhanglin
	 */	
	public class BaseSocket extends EventDispatcher
	{
		public var isConnected:Boolean = false; //标识是否与服务器连接成功
		private var _socket:Socket = null; //socket实例
		protected var _data:ByteArray = null;//正文数据
		protected var _code:uint = 0;//验证码
		
		public function set socket( value:Socket ):void {
			dispose(true);
			_socket = value ;
			isConnected = _socket.connected ;
			_data = new ByteArray();
			addListeners() ;
		}
		
		/**
		 * 构造函数 
		 * @singTon 
		 */		
		public  function BaseSocket()
		{
			//初始化
			_socket = new Socket();
			_data = new ByteArray();
		}
		/**
		 * 连接服务器 
		 * @param host 主机名或IP
		 * @param port 端口
		 * 
		 */		
		public function connect(host:String,port:uint):void{
			//关闭原来的连接
			if(_socket!=null&&_socket.connected){
				_socket.close();
			}
			//连接服务器
			_socket.connect(host,port);
			//添加socket侦听
			addListeners();
		}
		
		/**
		 * 添加socket侦听 
		 */		
		protected function addListeners():void
		{
			//添加侦听
			_socket.addEventListener(Event.CLOSE,onSocketCloseHandler);
			_socket.addEventListener(IOErrorEvent.IO_ERROR,onSocketErrorHandler);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA,receiveDataHandler);
			_socket.addEventListener(Event.CONNECT,onConnectedHandler);
		}
		
		/**
		 * 连接服务器成功
		 * */
		protected function onConnectedHandler(e:Event):void{
			isConnected = true;
			trace("和服务器连接成功...");
			dispatchEvent( e ) ;
		}
		/**
		 * 和服务器断开连接  
		 * @param e
		 * 
		 */		
		protected function onSocketCloseHandler(e:Event):void{
			isConnected = false ;
			trace("断开与服务器的连接");
			dispatchEvent( e ) ;
		}
		/**
		 * IO读取错误 
		 * @param e
		 * 
		 */		
		protected function onSocketErrorHandler(e:IOErrorEvent):void{
			isConnected = false ;
			trace(e.text);
			dispatchEvent( e ) ;
		}
		
		/**
		 * 接收数据 
		 * 格式：总长度(uint)+验证码(byte)+时间(uint)+控制器byte+子类型byte+数据长度uint+数据
		 * @param e
		 */
		protected function receiveDataHandler(e:ProgressEvent):void
		{
			_socket.readBytes(_data,0, _socket.bytesAvailable);
			while(_data.bytesAvailable>0)
			{
				var tlen:uint = _data.readUnsignedInt(); //数据总长度 
				if( tlen-4 >_data.bytesAvailable){
					var temp:ByteArray = new ByteArray();
					temp.writeUnsignedInt(tlen);
					temp.writeBytes(_data,0,_data.bytesAvailable);
					_data = temp;
					return;
				}
			
				readData(_data);
				
				//重新初始化数组
				if(_data.bytesAvailable==0){
					_data.clear() ;
				}
			}
		}
		
		/**
		 *  子类重写
		 * @param bytes
		 */		
		protected function readData( bytes:ByteArray ):void
		{
			//例子:
			
//			//读取head
//			var mainType:int = bytes.readUnsignedByte() ;
//			var sonType:int = bytes.readUnsignedByte() ;
//			//读取body
//			var body:SocketObject = new SocketObject( bytes , false );
//			//发送事件 
//			var evt:GameSocketEvent ;
//			switch( mainType)
//			{
//				case SocketLoginType.LOGIN:
//					evt = new SocketEvent( GameSocketEvent.LOGIN , sonType , body );
//					break ;
//				case SocketRoomType.ROOM:
//					evt = new SocketEvent( GameSocketEvent.ROOM , sonType , body );
//					break ;
//			}
//			if(evt) dispatchEvent( evt );
		}

		protected function send( bytes:ByteArray):void{
			if(!isConnected){
				trace("未连接服务器");
				return;
			}
			_socket.writeBytes( bytes);
			_socket.flush();
		}
		
		/**
		 *  释放资源 
		 * @param gc
		 */		
		public function dispose( gc:Boolean = false ):void {
			_socket.removeEventListener(Event.CLOSE,onSocketCloseHandler);
			_socket.removeEventListener(IOErrorEvent.IO_ERROR,onSocketErrorHandler);
			_socket.removeEventListener(ProgressEvent.SOCKET_DATA,receiveDataHandler);
			_socket.removeEventListener(Event.CONNECT,onConnectedHandler);
			
			_socket.close();
			_socket = null ;
			_data = null ;
		}
	}
}