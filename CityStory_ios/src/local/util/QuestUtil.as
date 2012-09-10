package local.util
{
	import local.enum.BuildingType;
	import local.model.BuildingModel;

	public class QuestUtil
	{
		private static var _instance:QuestUtil ;
		public static function get instance():QuestUtil {
			if(!_instance) _instance = new QuestUtil();
			return _instance;
		}
		//=======================================
		
		/**
		 * 返回地图上的建筑数量 
		 * @param name 建筑的名称
		 * @return 
		 */		
		public function getCountByName( name:String ):int 
		{
			var buildingModel:BuildingModel = BuildingModel.instance ;
			var value:int ;
			switch(name)
			{
				case BuildingType.BUSINESS:
					if(buildingModel.business){
						value = buildingModel.business.length ;
					}
					break ;
				case BuildingType.COMMUNITY:
					if(buildingModel.community){
						value = buildingModel.community.length ;
					}
					break ;
				case BuildingType.HOME:
					if(buildingModel.community){
						value = buildingModel.homes.length ;
					}
					break ;
				case BuildingType.DECORATION:
					if(buildingModel.decorations){
						value = buildingModel.decorations.length ;
					}
					break ;
				case BuildingType.WONDERS:
					if(buildingModel.wonders){
						value = buildingModel.wonders.length ;
					}
					break ;
				case BuildingType.INDUSTRY:
					if(buildingModel.industry){
						value = buildingModel.industry.length ;
					}
					break ;
			}
			return value;
		}
	
		
	}
}