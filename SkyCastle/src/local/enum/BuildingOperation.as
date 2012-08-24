package local.enum
{
	/**
	 * 枚举： 当前对地图上的建筑执行什么样的操作 
	 * @author zhouzhanglin
	 */	
	public class BuildingOperation
	{
		/** 无任何操作 */
		public static const NONE:String = "none";
		/**买新的建筑 */
		public static const BUY:String="buy";
		/** 移动 */
		public static const MOVE:String= "move";
		/** 旋转 */
		public static const ROTATE:String = "rotate";
		/** 回收 */
		public static const STASH:String = "stash";
		/** 卖出 */
		public static const SELL:String = "sell";
		/** 使用收藏箱中的建筑 */
		public static const PLACE_STASH:String = "placeStash";
	}
}