package local.model
{
	import flash.utils.Dictionary;
	
	import local.vo.BaseBuildingVO;

	/**
	 * 商店数据 
	 * @author zzhanglin
	 */	
	public class ShopModel
	{
		private static var _instance:ShopModel;
		public static function get instance():ShopModel
		{
			if(!_instance) _instance = new ShopModel();
			return _instance; 
		}
		//=================================
		
		/** 基础的一些树石头 */
		public var basicBuildings:Vector.<BaseBuildingVO> = new Vector.<BaseBuildingVO>();
		
		/** 所有的建筑BaseBuildingVO */
		public var baseBuildings:Vector.<BaseBuildingVO> ;
		
		/** 商店里所有的建筑 数据，key为name , value 为BaseBuildingVO */
		public var allBuildingHash:Dictionary  ;
	
	}
}