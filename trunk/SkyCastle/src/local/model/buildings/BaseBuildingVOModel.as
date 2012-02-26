package local.model.buildings
{
	import flash.utils.Dictionary;
	
	import local.model.buildings.vos.BaseBuildingVO;

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
		private var _buildingBaseVOHash:Dictionary  ;
		
		/**
		 * 解析加载的配置文件 
		 * @param config
		 */		
		public function parseConfig( config:XML ):void
		{
			_buildingBaseVOHash = new Dictionary();
			
		}
		
		/**
		 * 通过baseId获取BuildingBaseVO 
		 * @param baseId
		 * @return  BuildingBaseVO
		 */		
		public function getBaseVOById( baseId:String):BaseBuildingVO
		{
			var vo:BaseBuildingVO ;
			if(_buildingBaseVOHash){
				vo =  _buildingBaseVOHash[baseId];
			}
			return vo ;
	}
}