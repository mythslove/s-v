package models
{
	import bing.utils.XMLAnalysis;
	
	import flash.utils.Dictionary;
	
	import models.vos.BuildingVO;

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
		public function get houseArray():Vector.<BuildingVO>
		{
			return _houseArray ;
		}
		
		public function parseConfig( config:XML ):void
		{
			var arr:Array = XMLAnalysis.createInstanceArrayByXML(config.shop[0].house[0] , BuildingVO , "," );
			_houseArray = Vector.<BuildingVO>( arr);
		}
	}
}