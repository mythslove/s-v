package local.model.vos
{
	/**
	 * 游戏基础配置 
	 * @author zzhanglin
	 */	
	public class ConfigBaseVO
	{
		public var baseBuildings:Object;  //基础建筑数据,key为baseId , value 为BaseBuildingVO等
		public var shopVO:ShopVO; //商店
		public var pickups:Object ; //所有的PickupVO，key为pickupId , vale为 PickupVO
		public var collections:Object ;//所有的收集物配置 , key为groupId , value为CollectionVO
	}
}