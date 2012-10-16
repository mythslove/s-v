package local.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.comm.GlobalDispatcher;
	import local.enum.VillageMode;
	import local.event.LevelUpEvent;
	import local.event.QuestEvent;
	import local.model.QuestModel;
	import local.util.AnalysisUtil;
	import local.util.PopUpManager;
	import local.util.SoundManager;
	import local.view.base.BaseView;
	import local.view.bottombar.BottomBar;
	import local.view.bottombar.GameTip;
	import local.view.quests.QuestCompletePopUp;
	import local.view.quests.QuestListPopUp;
	import local.view.topbar.QuestButton;
	import local.view.topbar.TopBar;
	import local.view.tutor.TutorView;
	import local.vo.QuestVO;
	
	public class CenterViewLayer extends BaseView
	{
		private static var _instance:CenterViewLayer;
		public static function get instance():CenterViewLayer
		{
			if(!_instance) _instance = new CenterViewLayer();
			return _instance; 
		}
		//======================================
		
		public var bottomBar:BottomBar;
		public var topBar:TopBar ;
		public var gameTip:GameTip ;
		public var questBtn:QuestButton;
		private var _questModel:QuestModel ;
		
		public function CenterViewLayer()
		{
			super();
			if(_instance) throw new Error("只能实例化一个CenterViewContainer");
			else _instance=this ;
			mouseEnabled = false ;	
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			bottomBar = new BottomBar();
			bottomBar.y=GameSetting.SCREEN_HEIGHT;
			addChild(bottomBar);
			
			topBar = new TopBar();
			addChild(topBar);
			topBar.x = (GameSetting.SCREEN_WIDTH-topBar.width)>>1 ;
			
			gameTip = new GameTip();
			gameTip. y = GameSetting.SCREEN_HEIGHT ;
			gameTip.x  = (GameSetting.SCREEN_WIDTH-gameTip.width)>>1 ;
			addChild(gameTip);
			
			questBtn = new QuestButton();
			questBtn.x=5;
			questBtn.y = topBar.height+50 ;
			addChild(questBtn);
			questBtn.addEventListener(MouseEvent.CLICK , btnQuestClickHandler );
			
			addChild(PopUpManager.instance);
			
			_questModel = QuestModel.instance ;
			initQuests();
		}
		
		/**
		 * 改变UI的状态， mode为VillageMode中的常量
		 * @param mode
		 */		
		public function changeStatus ( mode:String ):void
		{
			switch(mode)
			{
				case VillageMode.NORMAL :
					bottomBar.visible = true ;
					bottomBar.marketBtn.visible = true ;
					bottomBar.editorBtn.visible = true ;
					questBtn.visible = true ;
					bottomBar.doneBtn.visible = false ;
					bottomBar.storageBtn.visible = false ;
					topBar.visible = true ;
					break ;
				case VillageMode.EDIT :
					bottomBar.marketBtn.visible = false ;
					bottomBar.editorBtn.visible = false ;
					questBtn.visible = false ;
					bottomBar.doneBtn.visible = true ;
					bottomBar.storageBtn.visible = true ;
					topBar.visible = false ;
					break ;
				case VillageMode.BUILDING_STORAGE :
					bottomBar.doneBtn.visible = false ;
					bottomBar.storageBtn.visible = false ;
					questBtn.visible = false ;
					bottomBar.showStorage();
					topBar.visible = false ;
					break ;
				case VillageMode.BUILDING_SHOP :
					bottomBar.visible = false ;
					topBar.visible = false ;
					questBtn.visible = false ;
					break ;
				case VillageMode.EXPAND :
					bottomBar.marketBtn.visible = false ;
					bottomBar.editorBtn.visible = false ;
					questBtn.visible = false ;
					bottomBar.doneBtn.visible = true ;
					bottomBar.storageBtn.visible = false ;
					topBar.visible = false ;
					break ;
				case VillageMode.VISIT:
					gameTip.hide();
					bottomBar.marketBtn.visible = false ;
					bottomBar.editorBtn.visible = false ;
					questBtn.visible = false ;
					break ;
			}
		}
		
		
		//*****************************************************************************
		//处理任务
		//*****************************************************************************/
		
		private function initQuests():void
		{
			if(!_questModel.currentQuests || _questModel.currentQuests.length<QuestModel.instance.MAX_COUNT){
				_questModel.getCurrentQuests() ;
			}
			GlobalDispatcher.instance.addEventListener( QuestEvent.QUEST_COMPLETE , globalEvtHandler );
			GlobalDispatcher.instance.addEventListener( LevelUpEvent.LEVEL_UP , globalEvtHandler  );
			//判断是否有已经完成了的
			_questModel.checkCompleteQuest();
		}
		
		private function globalEvtHandler( e:Event):void
		{
			switch(e.type)
			{
				case QuestEvent.QUEST_COMPLETE:
					var vo:QuestVO = (e as QuestEvent).vo ;
					PopUpManager.instance.addQueuePopUp( QuestCompletePopUp.instance,true,1000);
					//获取新的任务
					_questModel.getCurrentQuests() ;
					_questModel.checkCompleteQuest();
					//统计
					AnalysisUtil.send("Progress-Quest Finished", {"Quest Name":vo.title});
					break;
				case LevelUpEvent.LEVEL_UP:
					_questModel.getCurrentQuests() ;
					_questModel.checkCompleteQuest();
					break;
			}
		}
		
		private function btnQuestClickHandler(e:MouseEvent):void
		{
			e.stopPropagation();
			SoundManager.instance.playButtonSound();
			if(GameData.isShowTutor){
				TutorView.instance.clearMask();
			}
			PopUpManager.instance.addQueuePopUp( QuestListPopUp.instance);
		}
		
		//*****************************************************************************
		//*****************************************************************************
		
	}
}