package local.model.vos
{
	import local.model.buildings.BaseBuildingVOModel;
	import local.model.buildings.vos.BaseBuildingVO;

	/**
	 * 商店itemVO 
	 * @author zhouzhanglin
	 */	
	public class ShopItemVO
	{
		public var shopId:String ;
		public var itemId:String ;
		public var itemType:String ;
		public var payType:int ;
		public var price:int ;
		public var useableLevel:int ;
		public var flag:String ;
		
		
		protected var _baseVO:BaseBuildingVO;
		/** 建筑的基础VO*/
		public function get baseVO():BaseBuildingVO
		{
			if( !_baseVO) {
				_baseVO = BaseBuildingVOModel.instance.getBaseVOById( itemId)  ;
			}
			return _baseVO;
		}
		public function set baseVO( value:BaseBuildingVO ):void{
			this._baseVO = value ;
		}
	}
}