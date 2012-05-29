package local.model
{
	import bing.amf3.ResultEvent;
	import bing.utils.SystemUtil;
	
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;
	
	import local.comm.GameRemote;
	import local.comm.GlobalDispatcher;
	import local.enum.QuestType;
	import local.events.QuestEvent;
	import local.model.vos.QuestVO;
	import local.utils.PopUpManager;
	import local.views.quest.QuestCompletePopUp;

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
		/**
		 * 构造函数 
		 * 注册外部调用的方法
		 */		
		public function QuestModel()
		{
			ExternalInterface.addCallback( "like" , like );
			ExternalInterface.addCallback( "addFriend" , addFriend );
			ExternalInterface.addCallback( "sendGift" , sendGift );
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
			SystemUtil.debug("返回数据：",e.service+"."+e.method , e.result );
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
					if( vo.isAccept && !vo.isReceived && !vo.isComplete && vo.update(questType , sonType , num , time ) )
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
				if(vo.isAccept && !vo.isReceived && !vo.isComplete && vo.checkComplete()  ){
					vo.isComplete=true;
					var questComPop:QuestCompletePopUp = new QuestCompletePopUp( vo );
					PopUpManager.instance.addQueuePopUp( questComPop );
				}
			}
		}
		
		
		
		public function like(value:int=1):void
		{
			updateQuests( QuestType.LIKE ) ;
		}
		
		public function sendGift( value:int=1 ):void
		{
			updateQuests( QuestType.SEND_GIFT ) ;
		}
		
		public function addFriend( value:int =1 ):void
		{
			updateQuests( QuestType.ADD_FRIEND ) ;
		}
	}
}