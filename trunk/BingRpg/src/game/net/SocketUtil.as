package game.net
{
	import game.events.SocketEvent;

	public class SocketUtil extends BaseSocket
	{
		
		override protected function handleMsg( e:SocketEvent ):void
		{
			trace("接收消息：controlId:"+e.control +"    ,sonType:"+ e.sonType+"    ,真实数据长度"+e.data.bytesAvailable);
			
			var socketEvent:SocketEvent = null;
			
			switch(e.control){
				case MsgType.LOGIN: //登陆事件
					socketEvent = new SocketEvent(SocketEvent.LOGIN);
					break;
				case MsgType.ROOM: //房间
					socketEvent = new SocketEvent(SocketEvent.ROOM);
					break;
				case MsgType.GAME: //游戏
					socketEvent = new SocketEvent(SocketEvent.GAME);
					break ;
			}
			
			if(socketEvent!=null){
				socketEvent.data = e.data ;
				socketEvent.control = e.control ;
				socketEvent.time = e.time ;
				socketEvent.sonType = e.sonType ;
				socketEvent.len = e.len ;
				dispatchEvent(socketEvent);//抛出事件
			}
		}
	}
}