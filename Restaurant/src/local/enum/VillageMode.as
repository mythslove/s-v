package local.enum
{
	/**
	 * 村庄的状态 
	 * @author zhouzhanglin
	 */	
	public class VillageMode
	{
		
		/**
		 * 正常状态 
		 */		
		public static const NORMAL:String = "normal";
		
		/**
		 * 编辑地图状态 
		 */		
		public static const EDIT:String = "edit";
		
		/**
		 * 添加商店中的建筑
		 */		
		public static const ITEM_SHOP:String = "itemShop";
		/**
		 * 添加收藏箱中的建筑
		 */		
		public static const ITEM_STORAGE:String = "itemStorage";
		
		/**
		 * 扩地 
		 */		
		public static const EXPAND:String = "expand";
		
		/**
		 * 在别人的村庄
		 */		
		public static const VISIT:String= "visit";
	}
}