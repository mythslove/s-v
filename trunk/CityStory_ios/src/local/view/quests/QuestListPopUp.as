package local.view.quests
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import local.comm.GameSetting;
	import local.map.GameWorld;
	import local.model.QuestModel;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.btn.PopUpCloseButton;
	import local.vo.QuestVO;

	public class QuestListPopUp extends BaseView
	{
		private static var _instance:QuestListPopUp;
		public static function get instance():QuestListPopUp{
			if(!_instance) _instance = new QuestListPopUp();
			return _instance ;
		}
		//=====================================
		public var btnClose:PopUpCloseButton ;
		public var container:Sprite;
		//=====================================
		
		public function QuestListPopUp(){
			super();
			btnClose.addEventListener(MouseEvent.CLICK , onMouseHandler );
		}
		
		override protected function addedToStageHandler( e:Event ):void
		{
			super.addedToStageHandler(e);
			mouseChildren=true;
			GameWorld.instance.stopRun();
			x = GameSetting.SCREEN_WIDTH>>1 ;
			y = GameSetting.SCREEN_HEIGHT>>1 ;
			TweenLite.from( this , 0.2 , { x:x-200 , ease: Back.easeOut , onComplete:showTweenOver });
		}
		
		private function showTweenOver():void{
			if(GameSetting.SCREEN_WIDTH<1024) GameWorld.instance.visible=false;
			showList();
		}
		
		private function onMouseHandler( e:MouseEvent ):void
		{
			switch( e.target )
			{
				case btnClose:
					close();
					break ;
			}
		}
		
		
		private function showList():void
		{
			var questModel:QuestModel = QuestModel.instance ;
			//判断是否有任务
			if(!questModel.currentQuests || questModel.currentQuests.length<questModel.MAX_COUNT){
				questModel.getCurrentQuests()
				questModel.checkCompleteQuest();
			}
			//当前的任务
			if(questModel.currentQuests){
				for each( var qvo:QuestVO in questModel.currentQuests){
					trace(qvo);
				}
			}
		}
		
		
		
		
		
		
		private function close():void{
			mouseChildren=false;
			TweenLite.to( this , 0.2 , { x:x+200 , ease: Back.easeIn , onComplete:onTweenCom});
		}
		private function onTweenCom():void{
			PopUpManager.instance.removeCurrentPopup() ;
		}
		
		override protected function removedFromStageHandler(e:Event):void{
			super.removedFromStageHandler(e);
			GameWorld.instance.run();
			GameWorld.instance.visible=true;
		}
	}
}