package local.events
{
	import flash.events.Event;
	
	/**
	 * 玩家信息事件 
	 * @author zzhanglin
	 */	
	public class UserInfoEvent extends Event
	{
		/**
		 * 玩家信息更新 
		 */		 
		public static const USER_INFO_UPDATED:String = "userInfoUpdated";
		
		/** 是否是当前玩家的信息改变，默认true */
		public var isMe:Boolean ;
		
		public function UserInfoEvent(type:String, isMe:Boolean = true ,  bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.isMe = isMe ;
		}
	}
}