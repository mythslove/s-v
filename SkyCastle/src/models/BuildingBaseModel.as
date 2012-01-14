package models
{
	import bing.ds.HashMap;
	import bing.utils.ObjectUtil;
	import bing.utils.XMLAnalysis;
	
	import flash.utils.Dictionary;
	
	import models.vos.BuildingBaseVO;

	public class BuildingBaseModel
	{
		private static var _instance:BuildingBaseModel ;
		public static function get  instance():BuildingBaseModel
		{
			if(!_instance) _instance = new BuildingBaseModel();
			return _instance ;
		}
		//====================================
		
		private var _buildingBaseVOHash:Dictionary  ;
		
		/**
		 * 解析加载的配置文件 
		 * @param config
		 */		
		public function parseConfig( config:XML ):void
		{
			_buildingBaseVOHash = new Dictionary();
			
			var arr:Array =  XMLAnalysis.createInstanceArrayByXML(config.buildings[0] , BuildingBaseVO ,",");
			const LEN:int = arr.length ;
			var baseVO:BuildingBaseVO ;
			for( var i:int =0  ; i<LEN ; ++i)
			{
				baseVO = arr[i];
				_buildingBaseVOHash[baseVO.baseId] = baseVO ;
			}
		}
		
		/**
		 * 通过baseId获取BuildingBaseVO 
		 * @param baseId
		 * @return  BuildingBaseVO
		 */		
		public function getBaseVOById( baseId:String):BuildingBaseVO
		{
			var vo:BuildingBaseVO ;
			if(_buildingBaseVOHash){
				vo =  _buildingBaseVOHash[baseId];
			}
			return vo ;
		}
	}
}