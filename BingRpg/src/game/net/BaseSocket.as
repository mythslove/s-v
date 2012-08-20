package   game.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import game.events.SocketEvent;
	
	/**
	 * 游戏socket基类 
	 * @author zhouzhanglin
	 * @date 2010/9/5
	 */	
	public class BaseSocket extends EventDispatcher
	{
		public var isConnected:Boolean = false; //标识是否与服务器连接成功
		private var _socket:Socket = null; //socket实例
		private var _data:ByteArray = null;//正文数据
		private var _code:uint = 0;//验证码
		
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
			
			//添加侦听
			_socket.addEventListener(Event.CLOSE,onClose);
			_socket.addEventListener(IOErrorEvent.IO_ERROR,onError);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA,receiveData);
			_socket.addEventListener(Event.CONNECT,onConn);
		}
		/**
		 * 连接服务器成功
		 * */
		private function onConn(e:Event):void{
			isConnected = true;
			this.dispatchEvent( e );
			trace("和服务器连接成功...");
		}
		/**
		 * 和服务器断开连接  
		 * @param e
		 * 
		 */		
		private function onClose(e:Event):void{
			trace("断开与服务器的连接");
		}
		/**
		 * IO读取错误 
		 * @param e
		 * 
		 */		
		private function onError(e:IOErrorEvent):void{
			trace(e.text);
		}
		
		/**
		 * 接收数据 
		 * 格式：总长度(uint)+验证码(byte)+时间(uint)+控制器byte+子类型byte+数据长度uint+数据
		 * @param e
		 */
		private function receiveData(e:ProgressEvent):void
		{
			_socket.readBytes(_data,0, _socket.bytesAvailable);
			
			while(_data.bytesAvailable>0){
			
				var tlen:uint = _data.readUnsignedInt(); //数据总长度 
				
				if( tlen-4 >_data.bytesAvailable){
					var tempByteArray:ByteArray = new ByteArray();
					
					tempByteArray.writeUnsignedInt(tlen);
					
					tempByteArray.writeBytes(_data,0,_data.bytesAvailable);
					
					_data = tempByteArray;
					
					return;
				}
			
				var control:uint = _data.readUnsignedByte();//控制器ID
				var sonType:uint = _data.readUnsignedByte() ;//子类型ID
				var time:Number = _data.readDouble(); //时间

				//真实数据长度
				var realDataLen:uint = _data.readUnsignedInt(); 
				//一条信息
				var oneInfo:ByteArray = new ByteArray();
				_data.readBytes(oneInfo,0 , realDataLen);
				var socketEvent:SocketEvent = new SocketEvent(SocketEvent.ALL) ;
				socketEvent.data = oneInfo;
				socketEvent.len = oneInfo.length;
				socketEvent.time = time ;
				socketEvent.control = control;
				socketEvent.sonType=sonType ;
				handleMsg(socketEvent);
				
				//重新初始化数组
				if(_data.bytesAvailable==0){
					_data = new ByteArray();
				}
			}
		}
		/**
		 * 处理接收的信息  ，在子类中重写
		 * @param e
		 */		
		protected function handleMsg( e:SocketEvent ):void{
			
		}
		
		/**
		 * send byteArray
		 * @param realData
		 * @param control 
		 * 
		 */		
		public function send( realData:ByteArray, control:uint , sonType:uint):void{
			if(!isConnected){
				trace("Failed to connect to socket server");
				return;
			}
			try{
				var tempByteArray:ByteArray = new ByteArray();
				//写数据：总长度(uint)+验证码(byte)+时间(uint)+控制器byte+子类型byte+数据长度uint+数据
				tempByteArray.writeUnsignedInt( realData.length+18); //总长度
				tempByteArray.writeByte(control); //控制器 1
				tempByteArray.writeByte(sonType); //子类型 1
				tempByteArray.writeDouble((new Date()).getTime()); //时间 8
				tempByteArray.writeUnsignedInt( realData.length); //真实数据的长度 4
				tempByteArray.writeBytes(realData,0 , realData.length); //数据
				trace("长度",tempByteArray.length);
				_socket.writeBytes(tempByteArray,0,tempByteArray.length);
				_socket.flush();
			}catch(error:Error){
				throw new Error(error.message);
			}
		}
		
		/**
		 *  释放资源 
		 * @param gc
		 */		
		public function dispose( gc:Boolean = false ):void {
			_socket.close();
			_socket = null ;
			_data = null ;
		}
	}
}