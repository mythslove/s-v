package local.enum
{
	/**
	 * 建筑当前的状态 
	 * @author zzhanglin
	 */	
	public class BuildingStatus
	{
		/**
		 * 没有状态 
		 */		
		public static const NONE:int = 0 ;
		
		/**
		 * 修建或生长中 
		 */		
		public static const BUILDING:int = 1 ;
		
		/**
		 *  修建或生长完成
		 */		
		public static const BUILD_COMPLETE:int = 2;
		
		/**
		 * 生产或生长中 
		 */		
		public static const PRODUCTION:int = 3 ;
		
		/**
		 * 生产或生长完成 
		 */		
		public static const PRODUCT_COMPLETE:int = 4 ;
	}
}