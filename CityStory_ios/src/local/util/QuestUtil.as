package local.util
{
	import local.comm.GlobalDispatcher;
	import local.enum.BuildingStatus;
	import local.enum.QuestType;
	import local.event.QuestEvent;
	import local.model.BuildingModel;
	import local.model.CompsModel;
	import local.model.QuestModel;
	import local.vo.BuildingVO;
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
		
		/**
		 * 处理OwnBuilding和OwnType这两种任务 
		 * @param questType
		 * @param sonType
		 */		
		public function handleOwn( questType:String , sonType:String ):void
		{
			var isUpdate:Boolean ;
			var currentQuests:Vector.<QuestVO> = QuestModel.instance.currentQuests ;
			//循环数组，判断是否有接受了该类任务，并且没有完成，则在此任务的相应类型数量上减1
			var arr:Vector.<BuildingVO> = BuildingModel.instance.getArrByType( sonType );
			var num:int ;
			if(arr){
				for each( var vo:QuestVO in currentQuests)
				{
					if( vo.isAccept && !vo.isComplete )
					{
						num = 0 ;
						switch( questType)
						{
							case QuestType.OWN_BUILDING:
								num = BuildingModel.instance.getCountByName( questType , sonType ) ;
								break ;
							case QuestType.OWN_TYPE:
								num = BuildingModel.instance.getCountByType questType ) ;
								break ;
							case QuestType.OWN_COMP:
								num = CompsModel.instance.getCompCount( sonType );
								break ;
						}
						if( updateSetCount( vo , questType , sonType , num ) ){
							isUpdate = true ;
						}
					}
				}
			}
			
			if(isUpdate) checkAllQuests();
		}
		
		
		/**
		 * 更新此quest，用于累加数值的
		 * @param questType
		 * @param sonType
		 * @param num
		 */		
		public function handleAddCount( questType:String , sonType:String = "" , num:int = 1 ):void
		{
			var isUpdate:Boolean ;
			var currentQuests:Vector.<QuestVO> = QuestModel.instance.currentQuests ;
			//循环数组，判断是否有接受了该类任务，并且没有完成，则在此任务的相应类型数量上减1
			for each( var vo:QuestVO in currentQuests)
			{
				if( vo.isAccept && !vo.isComplete && updateAddCount( vo , questType , sonType , num) )
				{
					isUpdate = true ;
				}
			}
			if(isUpdate) checkAllQuests();
		}
		
		/**
		 * 判断是否有quest完成 
		 */		
		public function checkAllQuests():void 
		{
			var currentQuests:Vector.<QuestVO> = QuestModel.instance.currentQuests ;
			for each( var vo:QuestVO in currentQuests )
			{
				if( vo.isAccept && !vo.isComplete && checkComplete(vo) ){
					vo.isComplete = true ;
					//抛出quest完成事件 
					var evt:QuestEvent = new QuestEvent(QuestEvent.QUEST_COMPLETE);
					evt.vo = vo ;
					GlobalDispatcher.instance.dispatchEvent( evt );
				}
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		//============下面是判断一个QuestVO=========================
		
		
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
							if(task.current!=num)  
								isUpdate = true ;
							task.current = num;
						}
					}else {
						if(task.current!=num)  
							isUpdate = true ;
						task.current =num;
					}
				}
			}
			return isUpdate;
		}
	}
}