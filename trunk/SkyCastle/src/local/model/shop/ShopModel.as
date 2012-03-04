package local.model.shop
{
	import bing.utils.XMLAnalysis;
	
	import local.model.buildings.vos.BuildingVO;

	public class ShopModel
	{
		private static var _instance:ShopModel;
		public static function get instance():ShopModel
		{
			if(!_instance) _instance = new ShopModel();
			return _instance; 
		}
		//=================================
		
		private var _houseArray:Vector.<BuildingVO> ;
		/** 商店中所有的房子 */
		public function get houseArray():Vector.<BuildingVO> {
			return _houseArray ;
		}
		
		private var _buildingArray:Vector.<BuildingVO>;
		/** 建筑 */
		public function get buildingArray():Vector.<BuildingVO> {
			return _buildingArray ;
		}
		
		private var _roadArray:Vector.<BuildingVO>;
		/** 商店中所有的路*/
		public function get roadArray():Vector.<BuildingVO> {
			return _roadArray ;
		}
		
		private var _treeArray:Vector.<BuildingVO>;
		/** 商店中所有的树*/
		public function get treeArray():Vector.<BuildingVO> {
			return _treeArray ;
		}
		
		private var _stoneArray:Vector.<BuildingVO>;
		/** 商店中所有的石头*/
		public function get stoneArray():Vector.<BuildingVO> {
			return _stoneArray ;
		}
		
		private var _rockArray:Vector.<BuildingVO>;
		/** 商店中所有的磐石*/
		public function get rockArray():Vector.<BuildingVO> {
			return _rockArray ;
		}
		
		private var _decorationArray:Vector.<BuildingVO>;
		/** 商店中所有的装饰*/
		public function get decorationArray():Vector.<BuildingVO> {
			return _decorationArray ;
		}
		
		private var _characterArray:Vector.<BuildingVO>;
		/** 商店中所有的人*/
		public function get characterArray():Vector.<BuildingVO> {
			return _characterArray ;
		}
		
		/**
		 * 解析config配置 
		 * @param config
		 */		
		public function parseConfig( config:XML ):void
		{
			//房子
			var arr:Array = XMLAnalysis.createInstanceArrayByXML(config.shop[0].house[0] , BuildingVO , "," );
			_houseArray = Vector.<BuildingVO>( arr);
			//建筑
			_buildingArray = new Vector.<BuildingVO>();
			_buildingArray = _houseArray.concat();
			//路
			arr = XMLAnalysis.createInstanceArrayByXML(config.shop[0].road[0] , BuildingVO , "," );
			_roadArray = Vector.<BuildingVO>( arr);
			//树
			arr = XMLAnalysis.createInstanceArrayByXML(config.shop[0].tree[0] , BuildingVO , "," );
			_treeArray = Vector.<BuildingVO>( arr);
			//石头
			arr = XMLAnalysis.createInstanceArrayByXML(config.shop[0].stone[0] , BuildingVO , "," );
			_stoneArray = Vector.<BuildingVO>( arr);
			//岩石
			arr = XMLAnalysis.createInstanceArrayByXML(config.shop[0].rock[0] , BuildingVO , "," );
			_rockArray = Vector.<BuildingVO>( arr);
			//装饰
			_decorationArray = new Vector.<BuildingVO>();
			_decorationArray =  _roadArray.concat(_treeArray).concat(_stoneArray).concat(_rockArray);
			//人
			arr =  XMLAnalysis.createInstanceArrayByXML(config.shop[0].character[0] , BuildingVO , "," );
			_characterArray = Vector.<BuildingVO>( arr);
		}
	}
}