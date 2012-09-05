package local.model
{
	import flash.utils.Dictionary;
	
	import local.view.shop.ShopItemRenderer;
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
		
		/** 商店里所有的建筑 数据，key为name , value 为BaseBuildingVO */
		public var allBuildingHash:Dictionary ;
		
		/** 商店里基础建筑 */
		public var basics:Vector.<BaseBuildingVO> ;
		
		/** 商店里的装饰品 */
		public var decors:Vector.<BaseBuildingVO> ;
		
		/** 商店里的商业建筑 */
		public var business:Vector.<BaseBuildingVO> ;
		
		/** 商店里的工厂建筑 */
		public var insdusty:Vector.<BaseBuildingVO> ;
		
		/** 商店里的奇迹建筑 */
		public var wonders:Vector.<BaseBuildingVO> ;
		
		/** 商店里的交流中心建筑 */
		public var community:Vector.<BaseBuildingVO> ;
		
		
		
		
		
		
		public var decorsRenderers:Vector.<ShopItemRenderer> ;
		
		public var businessRenderers:Vector.<ShopItemRenderer> ;
		
		public var insdustyRenderers:Vector.<ShopItemRenderer> ;
		
		public var wondersRenderers:Vector.<ShopItemRenderer> ;
		
		public var communityRenderers:Vector.<ShopItemRenderer> ;
		
	}
}