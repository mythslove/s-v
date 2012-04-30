package local.model.vos
{
	/**
	 * 收藏箱中的项 
	 * @author zzhanglin
	 */	
	public class StorageItemVO
	{
		public var id:int ; //buildingId
		public var baseId:String ; 
		public var buildTime:Number; //修建日期
		public var num:int ; //数量
		public var level:int = 1 ; //等级
	}
}