package local.enum
{
	/**
	 * 建筑当前的状态 
	 * @author zzhanglin
	 */	
	public class BuildingStatus
	{
		/** 砍完*/
		public static const CHOPED:int = -1 ;
		
		/** 无*/
		public static const NONE:int = 0 ;
		
		/** 砍树中 */
		public static const CHOP:int = 1 ;
		
		/** 修建中*/
		public static const BUILDING:int = 2 ;
		
		/** 完成 */
		public static const FINISH:int = 3 ;
		
		/** 生产中*/
		public static const PRODUCT:int = 4;
		
		/**可收获 */
		public static const HARVEST:int = 5;
		
		/** 仓库中*/
		public static const STORAGE:int = 6 ;
	}
}