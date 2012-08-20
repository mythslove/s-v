package game.net
{
	public class MsgType
	{
		//===========登陆系统1================
		/**
		 * 主控制：登陆系统 
		 */		
		public static const LOGIN:int = 1 ;
		/**
		 * 登陆子类：发送用户名和密码 
		 */		
		public static const LOGIN_SEND:uint = 1 ;
		/**
		 * 登陆子类：判断用户名和密码的返回信息 
		 */		
		public static const LOGIN_BACK:uint = 2 ;
		/**
		 * 登陆子类：获取我的角色列表的请求 
		 */		
		public static const LOGIN_ROLE_LIST_REQUEST:uint = 3 ;
		
		//===================================
		
		/**
		 * 控制器：房间
		 */
		public static const  ROOM:int = 2; 
		/**
		 * 获得房间列表
		 */
		public static const ROOM_getRoomList:int = 2 ;
	}
}