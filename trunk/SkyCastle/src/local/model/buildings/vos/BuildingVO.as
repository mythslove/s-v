package local.model.buildings.vos
{
	import local.model.buildings.BaseBuildingVOModel;
	import local.model.vos.ShopItemVO;

	/**
	 * 真实建筑的VO 
	 * @author zzhanglin
	 */	
	public class BuildingVO extends MapItemVO
	{
		/** 如果当前的建筑是计步数，则表示当前在哪一步*/
		public var step:int =1 ;
		
		/** 当前的建筑状态，为BuildingStaus中的常量*/
		public var buildingStatus:int ;
		
		/** 如果当前状态是时间计算，则表示时间戳*/
		public var statusTime:Number =0 ;
		
		/** 当前等级，默认为1 */
		public var level:int =1 ;
		
		/** 商店里面显示的支付方法 */
		public var payType:int ; 
		/** 商店里面显示的价格 */
		public var price:int ;
		
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
			return buildingVO ;
		}
	}
}