package local.enum
{
	public class BuildingStatus
	{
		public static const NONE:int = 0 ;
		
		/** 建造中*/
		public static const BUILDING:int = 1;
		/**  生产中 */
		public static const PRODUCTION:int = 2 ;
		/**  生产完成 */
		public static const PRODUCTION_COMPLETE:int = 3;
		/** 缺少材料，goods . 原料*/
		public static const LACK_MATERIAL:int =  4;
		
		/** 扩地中*/
		public static const EXPANDING:int = 7 ;
		/** 扩地完成  */
		public static const EXPAND_COMPLETE:int = 8 ; 
	}
}