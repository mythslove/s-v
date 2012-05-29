package local.events
{
	import flash.events.Event;
	
	import local.model.vos.FriendVO;

	/**
	 * 好友事件  
	 * @author zhouzhanglin
	 */	
	public class FriendEvent extends Event
	{
		/** 获取好友列表 */
		public static const GET_FRIENDS:String = "getFriends" ;
		/** 好友*/
		public var friends:Vector.<FriendVO> ;
		
		public function FriendEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}