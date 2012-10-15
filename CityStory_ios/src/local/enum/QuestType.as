package local.enum
{
	/**
	 * 任务类型，全为小写 
	 * @author zhouzhanglin
	 * 
	 */	
	public class QuestType
	{
		/**
		 * 拥有某个种建筑的数量，sonType为建筑的name ，如shoe home
		 */		
		public static const OWN_BUILDING:String = "ownbuilding";
		
		/**
		 * 拥有某一种类型的建筑数量，sonType为建筑的大类型，如wonders,commnuity,homes 
		 */	
		public static const OWN_TYPE:String = "owntype";
		
		/**
		 * 拥有某一种Compoent的数量，sonType为 Component的 name 
		 */		
		public static const OWN_COMP:String = "owncomp";
		
		/**
		 * 修建某个建筑 ，sonType为建筑的name
		 */		
		public static const BUILD:String = "build";
		
		/**
		 * 普通收获的次数 , sonType可以为BuildingType，如果没有，则为全部-------------------
		 */		
		public static const COLLECT:String = "collect";
		
		/**
		 * 砍树的数量 
		 */		
		public static const CHOP:String = "chop";
		
		/**
		 * 放置建筑 , sonType为 name
		 */		
		public static const PLACE:String = "place";
	}
}