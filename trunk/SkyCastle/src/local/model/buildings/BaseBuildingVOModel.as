package local.model.buildings
{
	import bing.utils.XMLAnalysis;
	
	import flash.utils.Dictionary;
	
	import local.enum.BuildingType;
	import local.model.buildings.vos.*;

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
			var vos:XMLList = config.buildings[0].vo;
			var len:int = vos.length();
			var baseVO:BaseBuildingVO ;
			var type:String ;
			for ( var i:int = 0 ; i<len ; ++i )
			{
				type = String(vos[i].@type) ;
				switch( type )
				{
					case BuildingType.BUILDING :
						baseVO = XMLAnalysis.createInstanceByXML( vos[i] , BaseBuildingVO ,"," ) as BaseBuildingVO;
						break ;
					case BuildingType.BUILDING_HOUSE :
						baseVO = XMLAnalysis.createInstanceByXML( vos[i] , BaseHouseVO ,"," ) as BaseHouseVO;
						break ;
					case BuildingType.BUILDING_FACTORY :
						baseVO = XMLAnalysis.createInstanceByXML( vos[i] , BaseFactoryVO ,"," ) as BaseFactoryVO;
						break ;
					case BuildingType.DECORATION :
						baseVO = XMLAnalysis.createInstanceByXML( vos[i] , BaseDecorationVO ,"," ) as BaseDecorationVO;
						break ;
					case BuildingType.DEC_TREE :
						baseVO = XMLAnalysis.createInstanceByXML( vos[i] , BaseTreeVO ,"," ) as BaseTreeVO;
						break ;
					case BuildingType.DEC_STONE :
						baseVO = XMLAnalysis.createInstanceByXML( vos[i] , BaseStoneVO ,"," ) as BaseStoneVO;
						break ;
					case BuildingType.DEC_ROAD :
						baseVO = XMLAnalysis.createInstanceByXML( vos[i] , BaseRoadVO ,"," ) as BaseRoadVO;
						break ;
					case BuildingType.PLANT :
						baseVO = XMLAnalysis.createInstanceByXML( vos[i] , BasePlantVO ,"," ) as BasePlantVO;
						break ;
					case BuildingType.PLANT_CROP :
						baseVO = XMLAnalysis.createInstanceByXML( vos[i] , BaseCropVO ,"," ) as BaseCropVO;
						break ;
					case BuildingType.PLANT_LAND :
						baseVO = XMLAnalysis.createInstanceByXML( vos[i] , BaseLandVO ,"," ) as BaseLandVO;
						break ;
					case BuildingType.CHACTERS:
						baseVO = XMLAnalysis.createInstanceByXML( vos[i] , BaseCharacterVO ,"," ) as BaseCharacterVO;
						break ;
				}
				_buildingBaseVOHash[ baseVO.baseId ] = baseVO ;
			}
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
}