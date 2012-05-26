package  local.views
{
	import flash.display.Sprite;
	
	import local.comm.GlobalDispatcher;
	import local.comm.GlobalEvent;
	import local.events.QuestEvent;
	import local.model.QuestModel;
	import local.model.vos.QuestVO;
	
	public class LeftBar extends Sprite
	{
		private static var _instance:LeftBar ;
		public static function get instance():LeftBar
		{
			if(!_instance) _instance = new LeftBar();
			return _instance;
		}
		//=======================
		private var _questModel:QuestModel ;
		private var _questContainer:Sprite ; //任务的容器
		
		public function LeftBar()
		{
			super();
			if(_instance) throw new Error(" 只能实例化一个LeftBar");
			else _instance = this ;
			mouseEnabled = false ;
			init();
		}
		
		private function init():void
		{
			_questModel = QuestModel.instance ;
			_questContainer = new Sprite();
			_questContainer.y = 100 ;
			_questContainer.x = 50 ;
			addChild( _questContainer );
			
			GlobalDispatcher.instance.addEventListener( QuestEvent.GET_QUEST_LIST , globalEvtHandler );
			QuestModel.instance.getQuests() ; //获取quests
		}
		
		private function globalEvtHandler( e:GlobalEvent ):void
		{
			switch( e.type)
			{
				case QuestEvent.GET_QUEST_LIST:
					var newQuests:Vector.<QuestVO> = ( e as QuestEvent).newQuests ;
					showQuests(newQuests);
					break ;
			}
		}
		
		/*显示任务列表*/
		private function showQuests( quests:Vector.<QuestVO> ):void
		{
			
		}
	}
}