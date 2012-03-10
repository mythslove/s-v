package local.events
{
	import flash.events.Event;
	
	/**
	 * 玩家信息事件 ，主要用来获取玩家的信息
	 * @author zzhanglin
	 */	
	public class UserInfoEvent extends Event
	{
		public static const EXP:String = "exp";
		public static const NAME:String ="name";
		public static const STONE:String ="stone";
		public static const WOOD:String ="wood";
		public static const CASH:String ="cash";
		public static const ENERGY:String="energy";
		
		/**
		 * 玩家信息更新 
		 */		 
		public static const USER_INFO_UPDATED:String = "userInfoUpdated";
		
		/** 是玩家哪个类型改变了 */
		public var updateType:String ;
		
		/** 是否是当前玩家的信息改变，默认true */
		public var isMe:Boolean ;
		
		public function UserInfoEvent(type:String, isMe:Boolean = true ,  bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.isMe = isMe ;
		}
	}
}