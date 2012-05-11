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
		 * 修建某种类型建筑的数量,sonType为建筑的type 
		 */		
		public static const BUILD_NUM_TYPE:String = "buildnumtype" ;
		/**
		 * 拥有建筑的数量，sonType为建筑的baseId 
		 */		
		public static const OWN_NUM:String = "ownnum" ;
		/**
		 * 拥有某有类型的建筑数量， sonType为建筑的type
		 */		
		public static const OWN_NUM_TYPE:String = "ownnumtype";
		/**
		 * 砍树，石头.. sonType为ItemType中的小类型(tree,stone,rock)
		 */		
		public static const CHOP:String = "chop"  ;
		/**
		 * 收获的次数 
		 */		
		public static const COLLECT_NUM:String = "collectnum" ;
		/**
		 * 拥有某种STONE_TREE_ROCK的数量 , sonType为ItemType中的小类型(tree,stone,rock)
		 */		
		public static var OWN_STONE_TREE_ROCK:String = "ownstr";
		/**
		 * 收集了某种STONE_TREE_ROCK的数量 , sonType为ItemType中的小类型(tree,stone,rock)
		 */		
		public static var GET_STONE_TREE_ROCK:String = "getstr";
		
		
		
		/**
		 * 收集pickup的数量，sonType为pkId 
		 */		
		public static const COLLECT_NUM_PICKUP:String = "collectnumpickup" ;
		/**
		 * 拥有某种pickup的数量，sonType为pkId 
		 */		
		public static const OWN_NUM_PICKUP:String = "ownnumpickup" ;
		
		
		
		
		/**
		 * 发送礼物给好友 
		 */		
		public static const SEND_GIFT:String = "sendgift" ;
		/**
		 * 拜访好友 
		 */		
		public static const INVITE:String = "invite" ;
		/**
		 * 帮助好友 
		 */		
		public static const HELP_FRIEND:String = "helpfriend" ;
		/**
		 * 添加好友 
		 */		
		public static const ADD_FRIEND:String = "addfriend"; 
		/**
		 *有多少好友 
		 */		
		public static const OWN_FRIEND:String = "ownfriend";
		/**
		 * 分享游戏 
		 */		
		public static const SHARE:String = "share" ;
		/**
		 * 村庄的Rank达到多少值 
		 */		
		public static const RANK:String = "rank"  ;
		/**
		 * 照相 
		 */		
		public static const PHOTO:String = "photo" ;
		/**
		 * 喜欢 
		 */		
		public static const LIKE:String =  "like" ;
		
		
		/**
		 * 用gem的金额
		 */		
		public static const CASH_PURCHASE:String = "cashpurchase" ;
		/**
		 * 用gem的次数 
		 */		
		public static const CASH_PURCHASE_NUM:String ="cashpurchasenum" ;
	}
}