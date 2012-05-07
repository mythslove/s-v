package local.model
{
	import local.comm.GameData;
	import local.enum.ItemType;
	import local.model.vos.ConfigBaseVO;
	import local.model.vos.ShopItemVO;
	/**
	 * 商店的Model 
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
		
		private var _houseArray:Vector.<ShopItemVO> ;
		/** 商店中所有的房子 */
		public function get houseArray():Vector.<ShopItemVO> {
			return _houseArray ;
		}
		private var _factoryArray:Vector.<ShopItemVO> ;
		/** 商店中所有的工厂 */
		public function get factoryArray():Vector.<ShopItemVO> {
			return _factoryArray ;
		}
		private var _plantArray:Vector.<ShopItemVO> ;
		/** 商店中所有的植物 */
		public function get plantArray():Vector.<ShopItemVO> {
			return _plantArray ;
		}
		private var _buildingArray:Vector.<ShopItemVO>;
		/** 建筑 */
		public function get buildingArray():Vector.<ShopItemVO> {
			return _buildingArray ;
		}
		
		private var _roadArray:Vector.<ShopItemVO>;
		/** 商店中所有的路*/
		public function get roadArray():Vector.<ShopItemVO> {
			return _roadArray ;
		}
		
		private var _treeArray:Vector.<ShopItemVO>;
		/** 商店中所有的树*/
		public function get treeArray():Vector.<ShopItemVO> {
			return _treeArray ;
		}
		
		private var _stoneArray:Vector.<ShopItemVO>;
		/** 商店中所有的石头*/
		public function get stoneArray():Vector.<ShopItemVO> {
			return _stoneArray ;
		}
		
		private var _rockArray:Vector.<ShopItemVO>;
		/** 商店中所有的磐石*/
		public function get rockArray():Vector.<ShopItemVO> {
			return _rockArray ;
		}
		
		private var _decorationArray:Vector.<ShopItemVO>;
		/** 商店中所有的装饰*/
		public function get decorationArray():Vector.<ShopItemVO> {
			return _decorationArray ;
		}
		
		private var _characterArray:Vector.<ShopItemVO>;
		/** 商店中所有的人*/
		public function get characterArray():Vector.<ShopItemVO> {
			return _characterArray ;
		}
		
		private var _allShopItemArray:Vector.<ShopItemVO>;
		/** 商店中所有的商品*/
		public function get allShopItemArray():Vector.<ShopItemVO> {
			return _allShopItemArray ;
		}
		
		/**
		 * 解析config配置 
		 * @param config
		 */		
		public function parseConfig( config:ConfigBaseVO ):void
		{
			if(!config.shopVO){
				return ;
			}
			//房子
			_houseArray = Vector.<ShopItemVO>( config.shopVO.houses );
			//工厂
			_factoryArray = Vector.<ShopItemVO>( config.shopVO.factorys );
			//建筑
			if(config.shopVO.buildings){
				_buildingArray = Vector.<ShopItemVO>( config.shopVO.buildings );
			}else{
				_buildingArray = new Vector.<ShopItemVO>();
			}
			_buildingArray = _buildingArray.concat(_houseArray).concat(_factoryArray);
			//农作物
			_plantArray = Vector.<ShopItemVO>( config.shopVO.plants );
			//路
			_roadArray = Vector.<ShopItemVO>( config.shopVO.roads);
			//树
			_treeArray = Vector.<ShopItemVO>(config.shopVO.trees);
			//石头
			_stoneArray = Vector.<ShopItemVO>(config.shopVO.stones);
			//岩石
			_rockArray = Vector.<ShopItemVO>( config.shopVO.rocks);
			//装饰
			_decorationArray = Vector.<ShopItemVO>(config.shopVO.decorations);
			if(GameData.isAdmin){
				_decorationArray =  _decorationArray.concat(_roadArray).concat(_treeArray).concat(_stoneArray).concat(_rockArray);
			}else{
				_decorationArray =  _decorationArray.concat(_roadArray);
			}
			//人
//			_characterArray = Vector.<ShopItemVO>( config.shopVO.characterArray);
			
			//所有
			_allShopItemArray = buildingArray.concat( decorationArray).concat(plantArray);
		}
		
		
		public function getBuildingShopItemByBaseId( itemId:String , type:int ):ShopItemVO
		{
			var arr :Vector.<ShopItemVO>= getArrayByType(type);
			for each( var vo:ShopItemVO in arr)
			{
				if(vo.itemId==itemId){
					return vo ;
				}
			}
			return null ;
		}
		
		public function getShopItemByItemId( itemId:String ):ShopItemVO
		{
			for each( var vo:ShopItemVO in _allShopItemArray)
			{
				if(vo.itemId==itemId){
					return vo ;
				}
			}
			return null ;
		}
		
		private function getArrayByType( type:int ):Vector.<ShopItemVO>
		{
			var arr:Vector.<ShopItemVO> ;
			switch(type)
			{
				case ItemType.BUILDING_HOUSE:
					arr = houseArray ;
					break ;
				case ItemType.BUILDING_FACTORY:
					arr =  _factoryArray ;
					break ;
				case ItemType.PLANT:
					arr = _plantArray ;
					break ;
			}
			return arr ;
		}
	}
}