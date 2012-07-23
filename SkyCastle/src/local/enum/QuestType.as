package local.enum
{
	/**
	 * 任务的大类型 
	 * @author zhouzhanglin
	 */	
	public class QuestType
	{
		/**
		 * 修建建筑数量， sonType为建筑baseId
		 */
		public static const BUILD_NUM:String  ="buildNum";
		/**
		 * 拥有建筑的数量，sonType为建筑的baseId 
		 */		
		public static const OWN_BUILDING:String = "ownbuilding" ;
		/**
		 * 砍树，石头,sonType为建筑的baseId 
		 */		
		public static const CHOP:String = "chop"  ;
		/**
		 * 收获建筑的次数
		 */		
		public static const COLLECT_BUILDING:String = "collectbuilding" ;
		/**
		 * 统计玩家的一些属性 , sonType为：stone,wood,coin,rank这些字符串
		 */		
		public static const PLAYER_SWCR:String = "playerswcr";
		/**
		 * 收集pickup的数量，sonType为pkId 
		 */		
		public static const COLLECT_PICKUP:String = "collectpk" ;
		/**
		 * 拥有某种pickup的数量，sonType为pkId 
		 */		
		public static const OWN_PICKUP:String = "ownpk" ;
		
		
		/**
		 * 发送礼物给好友
		 */		
		public static const SEND_GIFT:String = "sendgift" ;
		/**
		 * 拜访好友
		 */		
		public static const INVITE:String = "invite" ;
		/**
		 * 帮助好友的
		 */		
		public static const HELP_FRIEND:String = "helpfriend" ;
		/**
		 * 添加好友
		 */		
		public static const ADD_FRIEND:String = "addfriend"; 
		/**
		 * 分享游戏 
		 */		
		public static const SHARE:String = "share" ;
		/**
		 * 照相 
		 */		
		public static const PHOTO:String = "photo" ;
		/**
		 * 喜欢 
		 */		
		public static const LIKE:String =  "like" ;
		/**
		 *  兑换collection 
		 */
		public static const TURN_IN:String = "turnin";
		/**
		 * 战胜怪 
		 */		
		public static const DEFEAT_MOB:String = "defeatmob";
	}
}