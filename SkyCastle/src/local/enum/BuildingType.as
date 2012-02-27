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
		public static const BUILDING:String = "building"; 
		/** 建筑：房子*/
		public static const BUILDING_HOUSE:String = "house" ;
		/** 建筑：工厂 */
		public static const BUILDING_FACTORY:String = "factory" ;
		
		
		/**
		 * 大类：装饰 
		 */		
		public static const DECORATION:String = "decoration";
		/** 装饰：树，树藤*/
		public static const DEC_TREE:String = "tree" ;
		/** 装饰：石头 */
		public static const DEC_STONE:String = "stone" ;
		/** 装饰：路，草坪，水渠 */
		public static const DEC_ROAD:String = "road" ;
		
		
		/**
		 * 大类：种植 
		 */		
		public static const PLANT:String = "plant";
		/** 种植：土地 */
		public static const PLANT_LAND:String = "land" ;
		/** 种植：农作物*/
		public static const PLANT_CROP:String = "crop" ;
		
		
		/** 大类：人*/
		public static const CHACTERS:String = "character" ;
	}
}