package local.enum
{
	public class QuestType
	{
		/**
		 * 拥有某个种建筑的数量，sonType为BaseBuildingVO的name ，如shoe home
		 */		
		public static const OWN_BUILDING:String = "ownbuilding";
		
		/**
		 * 拥有某一种类型的建筑数量，sonType为 BuildingType中的主类型，如wonders,commnuity,homes 
		 */		
		public static const OWN_TYPE:String = "owntype";
		
		/**
		 * 修建某个建筑 ，sonType为BaseBuildingVO的name 
		 */		
		public static const BUILD:String = "build";
		
		/**
		 * 普通收获的次数 
		 */		
		public static const COLLECT_COIN:String = "collectcoin";
		
		/**
		 * 收获goods的次数 
		 */		
		public static const COLLECT_GOODS:String = "collectgoods";
		
		/**
		 * 砍树的数量 
		 */		
		public static const CHOP:String = "chop";
	}
}