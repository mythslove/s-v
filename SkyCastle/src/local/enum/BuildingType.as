package local.enum
{
	/**
	 * 建筑的类型
	 * 分为大类型和小类型 
	 * @author zzhanglin
	 */	
	public class BuildingType
	{
		
		/**
		 * 大类：建筑 
		 */		
		public static const BUILDING:int = 1; 
		/** 建筑：房子*/
		public static const BUILDING_HOUSE:int = 11 ;
		/** 建筑：工厂 */
		public static const BUILDING_FACTORY:int = 12 ;
		
		
		/**
		 * 大类：装饰 
		 */		
		public static const DECORATION:int = 2;
		/** 装饰：树，树藤*/
		public static const DEC_TREE:int = 21 ;
		/** 装饰：石头 */
		public static const DEC_STONE:int = 22 ;
		/** 装饰：路，草坪，水渠 */
		public static const DEC_ROAD:int = 23 ;
		
		
		/**
		 * 大类：种植 
		 */		
		public static const PLANT:int = 3;
		/** 种植：土地 */
		public static const PLANT_LAND:int = 31 ;
		/** 种植：农作物*/
		public static const PLANT_CROP:int = 32 ;
	}
}