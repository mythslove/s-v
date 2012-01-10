package models
{
	import bing.utils.XMLAnalysis;
	
	import models.vos.BuildingVO;

	/**
	 * 商店数据 
	 * @author zhouzhanglin
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
		
		private var _houseArray:Vector.<BuildingVO> ;
		/** 商店中所有的房子 */
		public function get houseArray():Vector.<BuildingVO>
		{
			return _houseArray ;
		}
		private var _roadArray:Vector.<BuildingVO>;
		/** 商店中所有的路*/
		public function get roadArray():Vector.<BuildingVO>
		{
			return _roadArray ;
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
			//路
			arr = XMLAnalysis.createInstanceArrayByXML(config.shop[0].road[0] , BuildingVO , "," );
			_roadArray = Vector.<BuildingVO>( arr);
		}
	}
}