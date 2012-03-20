package local.model.vos
{
	import local.model.buildings.BaseBuildingVOModel;
	import local.model.buildings.vos.BaseBuildingVO;

	/**
	 * 商店的项
	 * @author zhouzhanglin
	 */	
	public class ShopItemVO
	{
		public var shopId:String ; //商店的id，可以有多个商店
		public var itemId:String ; //item的id，商店中的唯一标识
		public var itemValue:String ; //混合型，可当作建筑的baseId,也可作为item的值
		public var itemType:String ; //item类型，ItemType中的常量
		public var payType:int ; //支付方式，PayType中的常量
		public var price:int ; //价格
		public var useableLevel:int ; //玩家到哪个等级才能使用
		public var flag:String="" ; //标志
		
		
		protected var _baseVO:BaseBuildingVO;
		/** 建筑的基础VO*/
		public function get baseVO():BaseBuildingVO
		{
			if( !_baseVO) {
				_baseVO = BaseBuildingVOModel.instance.getBaseVOById( itemValue)  ;
			}
			return _baseVO;
		}
		public function set baseVO( value:BaseBuildingVO ):void{
			this._baseVO = value ;
		}
	}
}