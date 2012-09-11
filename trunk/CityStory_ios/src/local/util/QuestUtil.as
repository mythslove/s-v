package local.util
{
	import local.comm.GlobalDispatcher;
	import local.event.QuestEvent;
	import local.model.QuestModel;
	import local.vo.QuestTaskVO;
	import local.vo.QuestVO;

	/**
	 * 任务的统计和处理 
	 * @author zhouzhanglin
	 */	
	public class QuestUtil
	{
		private static var _instance:QuestUtil;
		public static function get instance():QuestUtil
		{
			if(!_instance) _instance = new QuestUtil();
			return _instance; 
		}
		//=================================
		
		
		
		
		
		
		
		public function handleAddCount( questType:String , sonType:String = "" , num:int = 1 ):void
		{
			var currentQuests:Vector.<QuestVO> = QuestModel.instance.currentQuests ;
			//循环数组，判断是否有接受了该类任务，并且没有完成，则在此任务的相应类型数量上减1
			for each( var vo:QuestVO in currentQuests)
			{
				if( vo.isAccept && !vo.received && !vo.isComplete &&updateAddCount( vo , questType , sonType , num) )
				{
					checkAllQuests(); //判断是否有完成的quest
				}
			}
		}
		
		/**
		 * 判断是否有quest完成 
		 */		
		public function checkAllQuests():void 
		{
			var currentQuests:Vector.<QuestVO> = QuestModel.instance.currentQuests ;
			for each( var vo:QuestVO in currentQuests )
			{
				if( vo.isAccept && !vo.isComplete && !vo.received && checkComplete(vo) ){
					vo.isComplete = true ;
					//抛出quest完成事件 
					var evt:QuestEvent = new QuestEvent(QuestEvent.QUEST_COMPLETE);
					evt.vo = vo ;
					GlobalDispatcher.instance.dispatchEvent( evt );
				}
			}
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * 判断是否完成此quest所有的tasks
		 * @param questVO
		 * @return 
		 */		
		private function checkComplete( questVO:QuestVO):Boolean
		{
			var len:int = questVO.tasks.length ;
			var task:QuestTaskVO ;
			for(var i:int  = 0 ; i<len ; ++i ){
				task = questVO.tasks[i]  as QuestTaskVO;
				if(task.isComplete ){
//					if(!task.isSendAnalysis){
//						//统计
//						AnalysisUtil.send("Progress-Quest Goal Finished",
//							{"Goal with Quest Name":title+"-"+item.intro});
//						item.isSendAnalysis = true ;
//					}
				}else{
					return false ;
				}
			}
			return true;
		}
		
		
		
		
		/**
		 *  更新此quest，用于累加数值的
		 * @param questVO 任务
		 * @param questType 主类型
		 * @param sonType 子类型
		 * @param num 变化数量
		 * @param reutrn 如果有更新，则返回true
		 */		
		private function updateAddCount( questVO:QuestVO , questType:String , sonType:String="" , num:int = 1):Boolean {
			var isUpdate:Boolean ;
			var len:int = questVO.tasks.length ;
			var task:QuestTaskVO ;
			for(var i:int  = 0 ; i<len ; ++i){
				task = questVO.tasks[i]  as QuestTaskVO;
				if( task.questType==questType ) 	{
					if ( sonType ) {
						if ( !task.sonType ||  task.sonType==sonType ){
							task.current+=num;
							isUpdate = true ;
						}
					} else {
						task.current+=num;
						isUpdate = true ;
					}
				}
			}
			return isUpdate;
		}
		
		/**
		 *  更新此quest，主要用于直接赋值的
		 * @param questVO 任务
		 * @param questType 主类型
		 * @param sonType 子类型
		 * @param num 变化数量
		 * @param reutrn 如果有更新，则返回true
		 */		
		private function updateSetCount( questVO:QuestVO , questType:String , sonType:String="" , num:int = 1 ):Boolean {
			var isUpdate:Boolean = false ;
			var len:int = questVO.tasks.length ;
			var task:QuestTaskVO ;
			for(var i:int  = 0 ; i<len ; ++i) {
				task = questVO.tasks[i]  as QuestTaskVO;
				if( task.questType==questType ) 	
				{
					if ( sonType ){
						if ( !task.sonType || task.sonType == sonType ){
							task.current = num;
							isUpdate = true ;
						}
					}else {
						task.current =num;
						isUpdate = true ;
					}
				}
			}
			return isUpdate;
		}
	}
}