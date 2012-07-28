package local.views.quest
{
	import bing.components.button.BaseButton;
	import bing.components.events.ToggleItemEvent;
	import bing.utils.ContainerUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import local.comm.GameSetting;
	import local.comm.GlobalDispatcher;
	import local.events.QuestEvent;
	import local.model.QuestModel;
	import local.utils.PopUpManager;
	import local.utils.SoundManager;
	import local.views.base.BaseView;
	import local.views.loading.SkinLoading;

	/**
	 * 任务列表窗口，显示当前所有的任务和已经完成了的任务
	 * @author zzhanglin
	 */	
	public class QuestListPopUp extends BaseView
	{
		public var tabMenu:QuestListTabMenu ;
		public var btnClose:BaseButton ;
		public var container:Sprite ;
		//==============================
		private var _loading:SkinLoading ;
		
		public function QuestListPopUp()
		{
			super();
			x = GameSetting.SCREEN_WIDTH>>1;
			y = GameSetting.SCREEN_HEIGHT>>1;
		}
		
		override protected function added():void
		{
			TweenLite.from(this,0.3,{x:x-200 , ease:Back.easeOut });
			SoundManager.instance.playSoundPopupShow();
			btnClose.addEventListener( MouseEvent.CLICK , closeClickHandler , false , 0 , true );
			tabMenu.addEventListener(ToggleItemEvent.ITEM_SELECTED , tabMenuHandler , false , 0 , true ) ;
			GlobalDispatcher.instance.addEventListener( QuestEvent.GET_COMPLETED_QUESTS , globalEvtHandler );
			GlobalDispatcher.instance.addEventListener( QuestEvent.LOADED_QUEST_CONFIG , globalEvtHandler );
			//显示已经激活的任务列表
			tabMenu.selectedName = tabMenu.btnActive.name;
		}
		
		private function globalEvtHandler( e:Event ):void
		{
			switch( e.type )
			{
				case QuestEvent.LOADED_QUEST_CONFIG :
					QuestModel.instance.getCompletedQuest() ;
					break ;
				case QuestEvent.GET_COMPLETED_QUESTS :
					removeChild(_loading);
					mouseChildren = false ;
					showCompletedQuests();
					break ;
			}
		}
		
		/* 主分类菜单按钮单击*/
		private function tabMenuHandler( e:ToggleItemEvent):void 
		{
			SoundManager.instance.playSoundClick();
			switch(  e.selectedName )
			{
				case tabMenu.btnActive.name:
					showActiveQuests() ;
					break ;
				case tabMenu.btnCompleted.name:
					_loading = new SkinLoading();
					addChild(_loading);
					QuestModel.instance.loadQuestConfig();
					break ;
			}
		}
		
		
		//============显示列表=======================
		
		//显示已经完成了的任务列表
		private function showCompletedQuests():void
		{
			ContainerUtil.removeChildren(container);
			if( QuestModel.instance.completedQuests && QuestModel.instance.completedQuests.length>0 ){
				
				var panel:QuestListPanel = new QuestListPanel(QuestModel.instance.completedQuests,"completed" );
				container.addChild(panel);
			}
		}
		//显示已经激活的任务列表，也就是当前的任务列表
		private function showActiveQuests():void
		{
			ContainerUtil.removeChildren(container);
			if( QuestModel.instance.currentQuests && QuestModel.instance.currentQuests.length>0 ){
				
				var panel:QuestListPanel = new QuestListPanel(QuestModel.instance.currentQuests,"active" );
				container.addChild(panel);
			}
		}
		
		//==============释放=======================
		private function closeClickHandler( e:MouseEvent ):void
		{
			mouseChildren = false ;
			TweenLite.to(this,0.3,{x:x+200 , ease:Back.easeIn , onComplete:tweenComplete});
			SoundManager.instance.playSoundClick();
		}
		private function tweenComplete():void {
			PopUpManager.instance.removeCurrentPopup(); 
		}
		
		override protected function removed():void
		{
			_loading = null ;
			btnClose.removeEventListener( MouseEvent.CLICK , closeClickHandler);
			tabMenu.removeEventListener(ToggleItemEvent.ITEM_SELECTED , tabMenuHandler ) ;
			GlobalDispatcher.instance.removeEventListener( QuestEvent.GET_COMPLETED_QUESTS , globalEvtHandler );
			GlobalDispatcher.instance.removeEventListener( QuestEvent.LOADED_QUEST_CONFIG , globalEvtHandler );
		}
	}
}