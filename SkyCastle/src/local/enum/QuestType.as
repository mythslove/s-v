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
		public static const BUILD_NUM:int  =1;
		/**
		 * 修建某种类型建筑的数量,sonType为建筑的type 
		 */		
		public static const BUILD_NUM_TYPE:int = 2 ;
		/**
		 * 拥有建筑的数量，sonType为建筑的baseId 
		 */		
		public static const OWN_NUM:int = 3 ;
		/**
		 * 拥有某有类型的建筑数量， sonType为建筑的type
		 */		
		public static const OWN_NUM_TYPE:int = 4;
		/**
		 * 砍树，石头.. sonType为ItemType中的小类型(tree,stone,rock)
		 */		
		public static const CHOP:int = 5  ;
		/**
		 * 收获的次数 
		 */		
		public static const COLLECT_NUM:int = 6 ;
		/**
		 * 拥有某种STONE_TREE_ROCK的数量 , sonType为ItemType中的小类型(tree,stone,rock)
		 */		
		public static var OWN_STONE_TREE_ROCK:int = 7;
		/**
		 * 收集了某种STONE_TREE_ROCK的数量 , sonType为ItemType中的小类型(tree,stone,rock)
		 */		
		public static var GET_STONE_TREE_ROCK:int = 8;
		
		
		
		/**
		 * 收集pickup的数量，sonType为pkId 
		 */		
		public static const COLLECT_NUM_PICKUP:int = 9 ;
		/**
		 * 拥有某种pickup的数量，sonType为pkId 
		 */		
		public static const OWN_NUM_PICKUP:int = 10 ;
		
		
		
		
		/**
		 * 发送礼物给好友 
		 */		
		public static const SEND_GIFT:int = 11 ;
		/**
		 * 拜访好友 
		 */		
		public static const INVITE:int = 12 ;
		/**
		 * 帮助好友 
		 */		
		public static const HELP_FRIEND:int = 13 ;
		/**
		 * 添加好友 
		 */		
		public static const ADD_FRIEND:int = 14; 
		/**
		 * 分享游戏 
		 */		
		public static const SHARE:int = 15 ;
		/**
		 * 村庄的Rank达到多少值 
		 */		
		public static const RANK:int = 16  ;
		/**
		 * 照相 
		 */		
		public static const PHOTO:int = 17 ;
		/**
		 * 喜欢 
		 */		
		public static const LIKE:int =  18 ;
		
		
		/**
		 * 用gem的金额
		 */		
		public static const CASH_PUCHASE:int =19 ;
		/**
		 * 用gem的次数 
		 */		
		public static const CASH_PUCHASE_NUM:int =20 ;
	}
}