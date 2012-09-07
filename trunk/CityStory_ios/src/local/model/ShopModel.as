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
		
		/** 商店里所有的建筑 数据，key为name , value 为BaseBuildingVO */
		public var allBuildingHash:Dictionary =new Dictionary() ;
		
		/** 商店里基础建筑 */
		public var basics:Vector.<BaseBuildingVO> = new Vector.<BaseBuildingVO>() ;
		
		/** 商店里的房子 */
		public var homes:Vector.<BaseBuildingVO> = new Vector.<BaseBuildingVO>() ;
		
		/** 商店里的装饰品 */
		public var decors:Vector.<BaseBuildingVO> = new Vector.<BaseBuildingVO>() ;
		
		/** 商店里的商业建筑 */
		public var business:Vector.<BaseBuildingVO> = new Vector.<BaseBuildingVO>() ;
		
		/** 商店里的工厂建筑 */
		public var industry:Vector.<BaseBuildingVO> = new Vector.<BaseBuildingVO>() ;
		
		/** 商店里的奇迹建筑 */
		public var wonders:Vector.<BaseBuildingVO> = new Vector.<BaseBuildingVO>() ;
		
		/** 商店里的交流中心建筑 */
		public var community:Vector.<BaseBuildingVO> = new Vector.<BaseBuildingVO>() ;
		
		
		
		public var homesRenderers:Vector.<ShopItemRenderer> = new Vector.<ShopItemRenderer>() ;
		
		public var decorsRenderers:Vector.<ShopItemRenderer> = new Vector.<ShopItemRenderer>() ;
		
		public var businessRenderers:Vector.<ShopItemRenderer> = new Vector.<ShopItemRenderer>() ;
		
		public var industryRenderers:Vector.<ShopItemRenderer> = new Vector.<ShopItemRenderer>() ;
		
		public var wondersRenderers:Vector.<ShopItemRenderer> = new Vector.<ShopItemRenderer>() ;
		
		public var communityRenderers:Vector.<ShopItemRenderer> = new Vector.<ShopItemRenderer>() ;
		
		
		
		public function parseConfig( config:XML ):void
		{
			if( config)
			{
				//手动写一个扩地时的建筑
				var baseVO:BaseBuildingVO  = new BaseBuildingVO() ;
				baseVO.name = "ExpandLandBuilding";
				baseVO.span = 4;
				baseVO.type = BuildingType.EXPAND_BUILDING ;
				allBuildingHash[baseVO.name] = baseVO ;
				
				
				var len:int = config.item.length();
				var item:* ;
				for( var i:int = 0 ; i<len ; ++i )
				{
					baseVO = new BaseBuildingVO();
					item = config.item[i];
					if( item.@name.length() ) baseVO.name = String( item.@name );
					if( item.@title.length() ) baseVO.title = String( item.@title );
					if( item.@span.length() ) baseVO.span = int( item.@span );
					if( item.@subClass.length() ) baseVO.subClass = String( item.@subClass );
					if( item.@type.length() ) baseVO.type = String( item.@type );
					allBuildingHash[baseVO.name] = baseVO ;
					//===================
					switch( baseVO.type)
					{
						case BuildingType.BASIC :
							basics.push( baseVO );
							break ;
						case BuildingType.HOME :
							homes.push( baseVO );
							homesRenderers.push( new ShopItemRenderer(baseVO) );
							break ;
						case BuildingType.DECORATION :
							decors.push( baseVO );
							decorsRenderers.push( new ShopItemRenderer(baseVO) );
							break ;
						case BuildingType.INDUSTRY :
							industry.push( baseVO );
							industryRenderers.push( new ShopItemRenderer(baseVO) );
							break ;
						case BuildingType.WONDERS :
							wonders.push( baseVO );
							wondersRenderers.push( new ShopItemRenderer(baseVO) );
							break ;
						case BuildingType.COMMUNITY :
							community.push( baseVO );
							communityRenderers.push( new ShopItemRenderer(baseVO) );
							break ;
						case BuildingType.BUSINESS :
							business.push( baseVO );
							businessRenderers.push( new ShopItemRenderer(baseVO) );
							break ;
					}
				}
			}
			else
			{
				trace("没有Shop数据");
			}
		}
	}
}