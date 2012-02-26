package local.model.buildings.vos
{
	/**
	 * 真实建筑的VO 
	 * @author zzhanglin
	 */	
	public class BuildingVO
	{
		public var id:String ;
		
		/** BaseBuildingVO的id*/
		public var baseId:String ;
		
		/** 如果当前的建筑是计步数，则表示当前在哪一步*/
		public var step:int ;
		
		/** 当前的建筑状态，为BuildingStaus中的常量*/
		public var buildingStatus:int ;
		
		/** 如果当前状态是时间计算，则表示时间戳*/
		public var statusTime:Number =0 ;
		
		/** 当前等级，默认为1 */
		public var level:int =1 ;
		
		/**支付方式,为PayType的常量*/
		public var payType:int ;
		
		/** 在商店中的价格 */
		public var price:int ;
		
		/** 当前位置 */
		public var nodeX:int ;
		/** 当前位置 */
		public var nodeZ:int ;
		
		/** 当前的方向，如果旋转过就是-1，默认为1 */
		public var scale:int =1 ;
	}
}