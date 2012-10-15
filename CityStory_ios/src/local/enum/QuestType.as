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
		 * 拥有某个建筑的数量，sonType为建筑的name 
		 */		
		public static const OWN_BD_BY_NAME:String = "own_bd_by_name";
		
		/**
		 * 拥有某种建筑的数量，sonType为建筑的大类型 
		 */		
		public static const OWN_BD_BY_TYPE:String = "own_bd_by_type";
		
		/**
		 * 拥有人口数量
		 */		
		public static const HAVE_POP:String = "have_pop";
		
		/**
		 * 修建某种建筑，sonType为建筑的name 
		 */		 
		public static const BUILD_BD_BY_NAME:String = "build_bd_by_name";
		
		/**
		 * 修建某类建筑，sonType为建筑的大类型 
		 */		
		public static const BUILD_BD_BY_TYPE:String = "build_bd_by_type";
		
		/**
		 * 在某类型的建筑上面花费多少coin, sontType为建筑的类型 
		 */		
		public static const SPEND_COIN_ON_BD_BY_TYPE:String = "spend_coin_on_bd_by_type";
		
		/**
		 * 扩地 
		 */		
		public static const EXPAND:String = "expand";
		
		/**
		 * 清除树的数量 
		 */		
		public static const CLEAR_TREE:String= "clear_tree";
		
		/**
		 * 为某种类型的建筑供应货物 , sonType为建筑的大类型 
		 */		
		public static const SUPPLY_BD_BY_TYPE:String = "supply_bd_by_type";
		
		/**
		 * 为某个建筑供应货物 , sonType为建筑的name
		 */		
		public static const SUPPLY_BD_BY_NAME:String = "supply_bd_by_name";
		
		/**
		 * 从某一类型的建筑上收获，sonType为建筑的大类型 
		 */		
		public static const COLLECT_BY_TYPE:String = "collect_by_type";
		
		/**
		 * 从某一类型的建筑上收获，sonType为建筑的子类型 
		 */		
		public static const COLLECT_BY_SONTYPE:String  = "collect_by_sontype";
		
		/**
		 * 从某一个建筑上收获，sonType为建筑的name
		 */		
		public static const COLLECT_BY_NAME:String  = "collect_by_name";
		
		/**
		 * 生产商品，sonType为商品的name 
		 */		
		public static const PRODUCT_GOODS:String = "product_goods";
		
		/**
		 *  放置某大类型的建筑. sonType为建筑的大类型
		 */		
		public static const PLACE_BY_TYPE:String =  "place_by_type";
		
	}
}