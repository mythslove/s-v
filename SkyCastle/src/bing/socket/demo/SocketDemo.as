package bing.socket.demo
{
	import bing.socket.BaseSocket;
	import bing.socket.SocketObject;
	import bing.socket.demo.enum.SocketLoginType;
	import bing.socket.demo.enum.SocketRoomType;
	
	import flash.utils.ByteArray;

	/**
	 * 继承BaseSocket的目的是处理数据的长度和头信息
	 * @author zhouzhanglin
	 */	
	public class SocketDemo extends BaseSocket
	{
		private static var _instance:SocketDemo ;
		public static function  get instance():SocketDemo {
			if(!_instance) _instance = new SocketDemo();
			return _instance; 
		}
		//=======================================
		//=======================================
		
		
		/**
		 *  发送数据到服务器
		 * @param mainType 数据主类型，正数
		 * @param sonType 数据子类型 ,正数
		 * @param body 数据body
		 */		
		public function sendMsg( mainType:int , sonType:int , body:SocketObject ):void
		{
			var data:ByteArray = body.build() ;
			var bytes:ByteArray = new ByteArray();
			
			bytes.writeUnsignedInt( data.length+6 ); //总长度 4
			//头信息
			bytes.writeByte(mainType); //主类型 1
			bytes.writeByte(sonType); //子类型 1
			//body数据
			bytes.writeBytes(data); 
			//发送
			send(bytes );
		}
		
		
		
		
		override protected function readData(bytes:ByteArray):void
		{
			//读取head
			var mainType:int = bytes.readUnsignedByte() ;
			var sonType:int = bytes.readUnsignedByte() ;
			//读取body
			var body:SocketObject = new SocketObject( bytes , false );
			//发送事件 
			var evt:SocketEvent ;
			switch( mainType)
			{
				case SocketLoginType.LOGIN:
					evt = new SocketEvent( SocketEvent.LOGIN , sonType , body );
					break ;
				case SocketRoomType.ROOM:
					evt = new SocketEvent( SocketEvent.ROOM , sonType , body );
					break ;
			}
			if(evt) dispatchEvent( evt );
		}
	}
}