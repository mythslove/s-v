package local.model
{
	import bing.utils.XMLAnalysis;
	
	import flash.utils.Dictionary;
	
	import local.comm.GameData;
	import local.model.vos.ShopItemVO;

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
		
		/**
		 * 解析config配置 
		 * @param config
		 */		
		public function parseConfig( config:XML ):void
		{
			//房子
			var arr:Array = XMLAnalysis.createInstanceArrayByXML(config.shop[0].house[0] , ShopItemVO , "," );
			_houseArray = Vector.<ShopItemVO>( arr);
			//建筑
			_buildingArray = new Vector.<ShopItemVO>();
			_buildingArray = _houseArray.concat();
			//路
			arr = XMLAnalysis.createInstanceArrayByXML(config.shop[0].road[0] , ShopItemVO , "," );
			_roadArray = Vector.<ShopItemVO>( arr);
			//树
			arr = XMLAnalysis.createInstanceArrayByXML(config.shop[0].tree[0] , ShopItemVO , "," );
			_treeArray = Vector.<ShopItemVO>( arr);
			//石头
			arr = XMLAnalysis.createInstanceArrayByXML(config.shop[0].stone[0] , ShopItemVO , "," );
			_stoneArray = Vector.<ShopItemVO>( arr);
			//岩石
			arr = XMLAnalysis.createInstanceArrayByXML(config.shop[0].rock[0] , ShopItemVO , "," );
			_rockArray = Vector.<ShopItemVO>( arr);
			//装饰
			arr = XMLAnalysis.createInstanceArrayByXML(config.shop[0].decoration[0] , ShopItemVO , "," );
			_decorationArray = Vector.<ShopItemVO>(arr);
			if(GameData.isAdmin){
				_decorationArray =  _decorationArray.concat(_roadArray).concat(_treeArray).concat(_stoneArray).concat(_rockArray);
			}else{
				_decorationArray =  _decorationArray.concat(_roadArray);
			}
			//人
			arr =  XMLAnalysis.createInstanceArrayByXML(config.shop[0].character[0] , ShopItemVO , "," );
			_characterArray = Vector.<ShopItemVO>( arr);
		}
	}
}