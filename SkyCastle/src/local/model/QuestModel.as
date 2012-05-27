package local.model
{
	import bing.amf3.ResultEvent;
	
	import flash.utils.Dictionary;
	
	import local.comm.GameRemote;
	import local.comm.GlobalDispatcher;
	import local.events.QuestEvent;
	import local.model.vos.QuestVO;

	/**
	 * 任务数据 
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
		
		public var currentQuests:Vector.<QuestVO> ;
		private var _ro:GameRemote ;
		public function get ro():GameRemote
		{
			if(!_ro){
				_ro = new GameRemote("commonserver");
				_ro.addEventListener(ResultEvent.RESULT , onResultHandler ); 
			}
			return _ro ;
		}
		
		public function getQuestById( qid:int ):QuestVO
		{
			if(currentQuests){
				var len:int = currentQuests.length ;
				for( var i:int =0 ; i<len ; ++i){
					if(currentQuests[i].qid==qid) {
						return currentQuests[i] ;
					}
				}
			}
			return null ;
		}
		
		/**
		 *  获取任务当前列表
		 */		
		public function getQuests():void
		{
			ro.getOperation("getQuestList").send() ;
		}
		
		private function onResultHandler( e:ResultEvent ):void
		{
			switch(e.method)
			{
				case "getQuestList":
					if(e.result)
					{
						//排除当前已经有的
						var dic:Dictionary = new Dictionary();
						if(currentQuests){
							for each( var vo:QuestVO in currentQuests){
								dic[vo.qid] = true ;
							}
						}
						var result:Vector.<QuestVO> = new Vector.<QuestVO>() ;
						var len:int = e.result.length ;
						for( var i:int = 0 ; i<len ; ++i )
						{
							vo = e.result[i] as QuestVO;
							if(vo && !dic[vo.qid]){
								result.push( vo ) ;
							}
						}
						var evt:QuestEvent = new QuestEvent(QuestEvent.GET_QUEST_LIST) ;
						evt.newQuests = currentQuests ;
						GlobalDispatcher.instance.dispatchEvent( evt );
						//当前的所有quests
						currentQuests = Vector.<QuestVO>( e.result );
					}
					break ;
			}
					
		}
		
		
		
		
		
		//=====================计算和统计quest中的数据===========================
		
		public function updateItems( questType:String , sonType:String = "" , num:int = 1  ):void
		{
			if(currentQuests==null) return  ;
			//循环数组，判断是否有接受了该类任务，并且没有完成，则在此任务的相应类型数量上加1
			var len:int = currentQuests.length;
			var vo:QuestVO = null  ;
			for( var i:int = 0 ; i<len ; i++ ){
				if(currentQuests[i] is QuestVO ){
					vo = currentQuests[i] as QuestVO;
					if( vo.isAccept && !vo.isReceived && !vo.isComplete &&vo.updateCount(questType , sonType , num ) ){
						
						//判断是否有完成的uest
//						checkCompleteQuest();
						
					}
				}
			}
		}
		
		public function updateTypeCount( questType:String , sonType:String = "" , num:int = 1 ):void
		{
			
		}
	}
}