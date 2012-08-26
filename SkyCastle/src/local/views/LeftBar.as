package  local.views
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import local.comm.GlobalDispatcher;
	import local.events.QuestEvent;
	import local.model.QuestModel;
	import local.model.vos.QuestVO;
	import local.utils.SoundManager;
	import local.views.quest.QuestBarItemRenderer;
	
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
			_questContainer.y = 150 ;
			_questContainer.x = 50 ;
			addChild( _questContainer );
			
			GlobalDispatcher.instance.addEventListener( QuestEvent.GET_QUEST_LIST , globalEvtHandler );
			setTimeout( QuestModel.instance.getQuests , 2000 ) ; //获取quests
		}
		
		private function globalEvtHandler( e:Event ):void
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
			if(quests)
			{
				var render:QuestBarItemRenderer ;
				for each( var vo:QuestVO in quests){
					render = new QuestBarItemRenderer(vo);
					render.y = 70*_questContainer.numChildren  ;
					_questContainer.addChild(render);
				}
				if(quests.length>0) SoundManager.instance.playSoundNewQuest();
				
				TweenLite.from( _questContainer , 0.5 , {x:-100 } );
			}
		}
		
		/**移除已经完成了的quest的icon*/
		public function removeQuestItemRenderer( qid:String ):void
		{
			var obj:DisplayObject = _questContainer.getChildByName( qid+"" );
			if(obj && _questContainer.contains(obj))
			{
				_questContainer.removeChild( obj ) ;
			}
			for( var i:int = 0 ; i<_questContainer.numChildren ; ++i)
			{
				obj = _questContainer.getChildAt(i);
				obj.y = (obj.height+10)*i ;
			}
		}
	}
}