package local.model
{
	import flash.utils.Dictionary;
	
	import local.enum.BuildingType;
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
	
		
		public var baseHomes:Vector.<BaseBuildingVO> = new Vector.<BaseBuildingVO>() ;
		
		public var baseDecors:Vector.<BaseBuildingVO> = new Vector.<BaseBuildingVO>() ;
		
		public var baseBusiness:Vector.<BaseBuildingVO> = new Vector.<BaseBuildingVO>() ;
		
		public var baseIndustry:Vector.<BaseBuildingVO> = new Vector.<BaseBuildingVO>() ;
		
		public var baseWonders:Vector.<BaseBuildingVO> = new Vector.<BaseBuildingVO>() ;
		
		public var baseCommunity:Vector.<BaseBuildingVO> = new Vector.<BaseBuildingVO>() ;
		
		/**
		 * 初始化商店数据和ShopItemRender 
		 */		
		public function initShopData():void
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
						baseHomes.push( baseVO  );
						break ;
					case BuildingType.DECORATION :
						baseDecors.push( baseVO  );
						break ;
					case BuildingType.INDUSTRY :
						baseIndustry.push( baseVO );
						break ;
					case BuildingType.WONDERS :
						baseWonders.push( baseVO );
						break ;
					case BuildingType.COMMUNITY :
						baseCommunity.push( baseVO );
						break ;
					case BuildingType.BUSINESS :
						baseBusiness.push( baseVO );
						break ;
				}
			}
		}
	}
}