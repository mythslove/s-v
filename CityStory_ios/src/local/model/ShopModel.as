package local.model
{
	import flash.utils.Dictionary;
	
	import local.enum.BuildingType;
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
		
		/** 基础的一些树石头 */
		public var basicBuildings:Vector.<BaseBuildingVO> = new Vector.<BaseBuildingVO>();
		
		/** 所有的建筑BaseBuildingVO */
		public var baseBuildings:Vector.<BaseBuildingVO> ;
		
		/** 商店里所有的建筑 数据，key为name , value 为BaseBuildingVO */
		public var allBuildingHash:Dictionary  ;
		
		public var homesRenderers:Vector.<ShopItemRenderer> = new Vector.<ShopItemRenderer>() ;
		
		public var decorsRenderers:Vector.<ShopItemRenderer> = new Vector.<ShopItemRenderer>() ;
		
		public var businessRenderers:Vector.<ShopItemRenderer> = new Vector.<ShopItemRenderer>() ;
		
		public var industryRenderers:Vector.<ShopItemRenderer> = new Vector.<ShopItemRenderer>() ;
		
		public var wondersRenderers:Vector.<ShopItemRenderer> = new Vector.<ShopItemRenderer>() ;
		
		public var communityRenderers:Vector.<ShopItemRenderer> = new Vector.<ShopItemRenderer>() ;
		
		
		/**
		 * 初始化商店数据和ShopItemRender 
		 */		
		public function initShopDataAndRender():void
		{
			//手动写一个扩地时的建筑
			var baseVO:BaseBuildingVO  = new BaseBuildingVO() ;
			baseVO.name = "ExpandBuilding";
			baseVO.span = 4;
			baseVO.type = BuildingType.EXPAND_BUILDING ;
			allBuildingHash[baseVO.name] = baseVO ;
			//遍历所有的建筑数据
			for each( baseVO in baseBuildings)
			{
				switch( baseVO.type)
				{
					case BuildingType.BASIC:
						basicBuildings.push( baseVO );
						break ;
					case BuildingType.HOME :
						homesRenderers.push( new ShopItemRenderer(baseVO) );
						break ;
					case BuildingType.DECORATION :
						decorsRenderers.push( new ShopItemRenderer(baseVO) );
						break ;
					case BuildingType.INDUSTRY :
						industryRenderers.push( new ShopItemRenderer(baseVO) );
						break ;
					case BuildingType.WONDERS :
						wondersRenderers.push( new ShopItemRenderer(baseVO) );
						break ;
					case BuildingType.COMMUNITY :
						communityRenderers.push( new ShopItemRenderer(baseVO) );
						break ;
					case BuildingType.BUSINESS :
						businessRenderers.push( new ShopItemRenderer(baseVO) );
						businessRenderers.push( new ShopItemRenderer(baseVO) );
						businessRenderers.push( new ShopItemRenderer(baseVO) );
						businessRenderers.push( new ShopItemRenderer(baseVO) );
						businessRenderers.push( new ShopItemRenderer(baseVO) );
						businessRenderers.push( new ShopItemRenderer(baseVO) );
						businessRenderers.push( new ShopItemRenderer(baseVO) );
						break ;
				}
			}
		}

	}
}