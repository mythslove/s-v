package local.model
{
	import local.enum.BuildingType;
	import local.vo.QuestVO;

	public class QuestModel
	{
		private static var _instance:QuestModel;
		public static function get instance():QuestModel
		{
			if(!_instance) _instance = new QuestModel();
			return _instance; 
		}
		//=================================
		
		public var currentQuests:Vector.<QuestVO> ;
		
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
		
		
		
		
		
		
		
		
		
		/**
		 * 统计任务项 
		 * @param questType
		 * @param sonType
		 * @param num
		 * @param time 时间限制
		 */		
		public function updateQuests( questType:String , sonType:String = "" , num:int = 1 , time:Number= NaN  ):void
		{
			if(currentQuests)
			{
				for each( var vo:QuestVO in currentQuests)
				{
					if( vo.isAccept && !vo.isComplete && vo.update(questType , sonType , num , time ) )
					{
						//判断是否有完成的quest
						checkCompleteQuest() ;
					}
				}
			}
		}
		
		/**判断是否有完成了的任务*/
		public function checkCompleteQuest():void
		{
			for each( var vo:QuestVO in currentQuests)
			{
				if(vo.isAccept  && !vo.isComplete && vo.checkComplete()  ){
					vo.isComplete=true;
					
				}
			}
		}
	}
}