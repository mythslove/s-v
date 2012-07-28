package local.views.quest
{
	import local.comm.GlobalDispatcher;
	import local.events.QuestEvent;
	import local.model.vos.QuestVO;
	import local.utils.PopUpManager;
	import local.views.base.BaseView;

	/**
	 * 任务的进度面板 
	 * @author zzhanglin
	 */	
	public class QuestProgressPanel extends BaseView
	{
		public var questVO:QuestVO ;
		private var _canSkip:Boolean ;
		
		public function QuestProgressPanel( questVO:QuestVO , canSkip:Boolean = true  )
		{
			super();
			mouseEnabled = false; 
			this.questVO = questVO ;
			this._canSkip = canSkip ;
		}
		
		override protected function added():void
		{
			var items:Array = questVO.items ;
			if(items)
			{
				var len:int = items.length ;
				var render:QuestProgressRenderer ;
				for( var i:int = 0 ; i<len ; ++i)
				{
					render = new QuestProgressRenderer(items[i]);
					render.y = render.height*i + 10 ;
					addChild(render);
					if(!_canSkip){
						render.btnSkip.enabled=false ;
					}
				}
			}
			
			
			GlobalDispatcher.instance.addEventListener( QuestEvent.QUEST_COMPLETED , questCompletedHandler );
		}
		
		private function questCompletedHandler( e:QuestEvent ):void
		{
			//如果当前有任务完成，并且是当前这个面板的话，则关闭当前面板，目的是显示任务完成面板
			if(e.completedQuestId==questVO.qid){
				PopUpManager.instance.removeCurrentPopup() ;
			}
		}
		
		
		override protected function removed():void
		{
			questVO = null ;
			GlobalDispatcher.instance.removeEventListener( QuestEvent.QUEST_COMPLETED , questCompletedHandler );
		}
				
	}
}