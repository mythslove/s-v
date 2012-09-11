package local.model
{
	import flash.utils.Dictionary;
	
	import local.enum.BuildingType;
	import local.vo.PlayerVO;
	import local.vo.QuestVO;

	/**
	 * 任务的数据 
	 * @author zhouzhanglin
	 */	
	public class QuestModel
	{
		private static var _instance:QuestModel;
		public static function get instance():QuestModel
		{
			if(!_instance) _instance = new QuestModel();
			return _instance; 
		}
		//=================================
		
		private const MAX_COUNT:int = 8 ; //最多读取前8个quests
		
		/** quest的hash，key为qid，value为questVO*/
		private var _questHash:Dictionary ;
		
		/** 所有的quest */
		public var allQuestArray:Vector.<QuestVO> ; 
		
		/** 当前的quests */
		public var currentQuests:Vector.<QuestVO>=new Vector.<QuestVO>() ;
		
		/** 完成了的quests ，key为qid，value为questVO*/
		public var completedQuests:Dictionary = new Dictionary() ;
		
		
		
		
		/**
		 * 获得当前最新的quests
		 * @return 
		 */		
		public function getCurrentQuests():Vector.<QuestVO>
		{
			var vo:QuestVO;
			for(var i:int = 0 ; i<currentQuests.length ; ++i){
				if(currentQuests[i].received){
					currentQuests.splice(i,1);
					i--;
				}
			}
			var len:int = allQuestArray.length ;
			for ( i = 0 ; i<len && currentQuests.length<MAX_COUNT ; ++i ) {
				vo = allQuestArray[i] ;
				if( checkCondition(vo) ){
					currentQuests.push( vo );
				}
			}
			return currentQuests;
		}
		
		/*判断是否可以接受这个quest*/
		private function checkCondition( vo:QuestVO ):Boolean
		{
			for each( var qvo:QuestVO in currentQuests){
				if(qvo.qid==vo.qid){
					return false ;
				}
			}
			if(!completedQuests[vo.qid]) //任务没有完成
			{
				var me:PlayerVO = PlayerModel.instance.me ;
				if(me.level>=vo.restrictLevel) //玩家等级符合
				{
					if(vo.restrictQuest) { //判断前置quest是否完成
						var len:int = vo.restrictQuest.length;
						for(var i:int = 0 ; i<len ; ++i){
							if(!completedQuests[ vo.restrictQuest[i] ]){
								return false ;
							}
						}
						return true ;
					}
					return true ;
				}
			}
			return false ;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
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