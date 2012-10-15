package local.model
{
	import flash.utils.Dictionary;
	
	import local.comm.GlobalDispatcher;
	import local.event.QuestEvent;
	import local.util.GameUtil;
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
		
		public const MAX_COUNT:int = 5 ; //最多读取前几个quests
		
		/** 所有的quest */
		public var allQuestArray:Vector.<QuestVO> ; 
		
		/** 当前的quests */
		public var currentQuests:Vector.<QuestVO> ;
		
		/** 完成了的quests ，key为qid，value为questVO*/
		public var completedQuests:Dictionary  ;
		
		/**
		 * 获得当前最新的quests
		 * @return 
		 */		
		public function getCurrentQuests():Vector.<QuestVO>
		{
			if(!currentQuests) currentQuests = new Vector.<QuestVO>();
			if(!completedQuests) completedQuests = new Dictionary();
			
			var vo:QuestVO;
			var dic:Dictionary = new Dictionary();
			for(var i:int = 0 ; i<currentQuests.length ; ++i){
				if(currentQuests[i].received){
					currentQuests.splice(i,1);
					i--;
				}else{
					dic[ currentQuests[i].qid ] = true ;
				}
			}
			var len:int = allQuestArray.length ;
			for ( i = 0 ; i<len && currentQuests.length<MAX_COUNT ; ++i )
			{
				vo = allQuestArray[i] ;
				if( !dic[vo.qid] && checkCondition(vo) ){
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
						var restrictQuestArray:Array = vo.restrictQuestArray ;
						var len:int = vo.restrictQuestArray.length;
						for(var i:int = 0 ; i<len ; ++i){
							if(!completedQuests[ restrictQuestArray[i] ]){
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
		
		/** 判断所有的任务中是否有任务完成*/
		public function checkCompleteQuest():void
		{
			for each( var vo:QuestVO in currentQuests)
			{
				if(vo.isAccept && !vo.received && !vo.isComplete && vo.checkComplete()  ){
					vo.isComplete=true;
					completedQuests[vo.qid]=vo;
					vo.received=true;
					//抛出quest完成事件 
					var evt:QuestEvent = new QuestEvent(QuestEvent.QUEST_COMPLETE);
					evt.vo = vo ;
					GlobalDispatcher.instance.dispatchEvent( evt );
					//领取奖励
					GameUtil.earnQuestRewards( vo.rewards );
				}
			}
		}
		
	}
}