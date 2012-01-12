package enums
{
	/**
	 * 建筑占用哪层的数据格子，因为有些建筑在Building层，却需要占用地面层(Ground)的格子
	 * @author zhouzhanglin
	 */	
	public class GridType
	{
		/**
		 * 地面层 
		 */		
		public static const GROUND:int =0 ;
		
		/**
		 * 建筑层 
		 */		
		public static const BUILDING:int = 1;
		
		/**
		 * 地面和建筑层，占用两层的数据
		 */		
		public static const GROUND_BUILDING:int = 2;
	}
}