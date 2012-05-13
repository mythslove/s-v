package local.model.buildings.vos
{
	import local.model.buildings.BaseBuildingVOModel;
	import local.model.vos.ShopItemVO;
	import local.model.vos.StorageItemVO;

	/**
	 * 真实建筑的VO 
	 * @author zzhanglin
	 */	
	public class BuildingVO 
	{
		/** 编号 */
		public var id:int = 0;
		
		/** 地图ID */
		public var mapId:String = "1";
		
		/** 建筑ID */
		public var baseId:String ;
		
		/** X坐标 */
		public var nodeX:int = 0;
		
		/** Z坐标 */
		public var nodeZ:int = 0;
		
		/** 当前的方向，如果旋转过就是-1，默认为1 */
		public var scale:int = 1;
		
		/** 如果当前的建筑是计步数，则表示当前在哪一步*/
		public var currentStep:int =0 ;
		
		/** 当前的建筑状态，为BuildingStaus中的常量*/
		public var buildingStatus:int ;
		
		/** 如果当前状态是时间计算，则表示时间戳*/
		public var statusTime:Number =0 ;
		
		/** 当前等级，默认为1 */
		public var level:int =1 ;
		
		/** 修建完成时的时间 */
		public var buildTime:int ;
		
		//===================================非必需
		/** 商店里的itemId*/
		public var shopItemId:String ;
		/** 商店里面显示的支付方法 */
		public var payType:int ; 
		/** 商店里面显示的价格 */
		public var price:int ;
		//=========================================
		
		
		
		
		protected var _baseVO:BaseBuildingVO;
		/** 建筑的基础VO*/
		public function get baseVO():BaseBuildingVO
		{
			if( !_baseVO) {
				_baseVO = BaseBuildingVOModel.instance.getBaseVOById( baseId)  ;
			}
			return _baseVO;
		}
		public function set baseVO( value:BaseBuildingVO ):void{
			this._baseVO = value ;
		}
		
		
		
		/**
		 * 通过商店中的shopItemVO来创建一个建筑VO 
		 * @param vo 商店中的ShopItemVO
		 * @return 
		 */		
		public static function createVoByShopItem( vo:ShopItemVO):BuildingVO
		{
			var buildingVO:BuildingVO = new BuildingVO();
			buildingVO.baseId = vo.itemValue ;
			buildingVO.payType = vo.payType;
			buildingVO.price = vo.price ;
			buildingVO.shopItemId = vo.itemId ;
			return buildingVO ;
		}
		
		/**
		 * 通过收藏箱中的StorageItemVo来创建一个建筑VO
		 * @param vo 收藏箱中的StorageItemVO
		 * @return 
		 */		
		public static function createVoByStorageItem( vo:StorageItemVO ):BuildingVO
		{
			var buildingVO:BuildingVO = new BuildingVO();
			buildingVO.baseId = vo.baseId ;
			buildingVO.buildTime = vo.buildTime ;
			buildingVO.id = vo.id ;
			buildingVO.level = vo.level ;
			return buildingVO ;
		}
	}
}