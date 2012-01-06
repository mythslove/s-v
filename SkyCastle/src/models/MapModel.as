package models
{
	import models.vos.BuildingVO;

	public class MapModel
	{
		private static var _instance:MapModel;
		public static function  get instnace():MapModel
		{
			if(!_instance) _instance = new MapModel();
			return _instance ;
		}
		//==================================
		/**
		 *地图上所有的房子 
		 */		
		public var house:Vector.<BuildingVO> =new Vector.<BuildingVO>();
	}
}