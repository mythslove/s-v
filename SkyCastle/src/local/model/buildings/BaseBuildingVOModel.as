package local.model.buildings
{
	import local.model.buildings.vos.*;
	import local.model.vos.ConfigBaseVO;

	/**
	 *  BaseBuildingVO数据存储和处理区 
	 * @author zzhanglin
	 */	
	public class BaseBuildingVOModel
	{
		private static var _instance:BaseBuildingVOModel ;
		public static function get instance():BaseBuildingVOModel
		{
			if(!_instance ) _instance = new BaseBuildingVOModel();
			return _instance; 
		}
		//-------------------------------------------------------------------------
		public var buildingBaseHash:Object;
		
		/**
		 * 解析加载的配置文件 
		 * @param config
		 */		
		public function parseConfig( config:ConfigBaseVO ):void
		{
			buildingBaseHash = config.baseBuildings ;
		}
		
		/**
		 * 通过baseId获取BuildingBaseVO 
		 * @param baseId
		 * @return  BuildingBaseVO
		 */		
		public function getBaseVOById( baseId:String):BaseBuildingVO
		{
			var vo:BaseBuildingVO ;
			if(buildingBaseHash && buildingBaseHash.hasOwnProperty(baseId)){
				vo =  buildingBaseHash[baseId] as BaseBuildingVO;
			}
			return vo ;
		}
	}
}