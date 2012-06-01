package local.views.quest
{
	import bing.components.button.BaseButton;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.comm.GameSetting;
	import local.model.QuestModel;
	import local.model.vos.QuestVO;
	import local.utils.PopUpManager;
	import local.utils.SoundManager;
	import local.views.LeftBar;
	import local.views.base.BaseView;
	import local.views.rewards.RewardsPanel;

	/**
	 * 任务完成弹出窗口 
	 * @author zzhanglin
	 */	
	public class QuestCompletePopUp extends BaseView
	{
		public var infoBg:Sprite ;
		public var txtTitle:TextField;
		public var txtCompleteInfo:TextField;
		public var btnClose:BaseButton ; //关闭按钮
		public var btnOk:BaseButton;
		public var container:Sprite ; //奖励面板的容器
		//======================================
		public var questVO:QuestVO ;
		
		public function QuestCompletePopUp( vo:QuestVO )
		{
			super();
			x = GameSetting.SCREEN_WIDTH>>1;
			y = GameSetting.SCREEN_HEIGHT>>1;
			this.questVO = vo ;
			infoBg.mouseChildren = infoBg.mouseEnabled = false  ;
			container.mouseChildren = container.mouseEnabled = false  ;
			txtTitle.mouseEnabled = txtCompleteInfo.mouseEnabled = false ;
		}
		
		override protected function added():void
		{
			TweenLite.from(this,0.3,{x:-200 , ease:Back.easeOut });
			SoundManager.instance.playSoundPopupShow();
			btnClose.addEventListener(MouseEvent.CLICK , onCloseHandler );
			btnOk.addEventListener(MouseEvent.CLICK , onCloseHandler );
			//显示详细
			txtTitle.text = questVO.title+"" ;
			txtCompleteInfo.text = questVO.completeMsg+"" ;
			txtCompleteInfo.y = infoBg.y + ( infoBg.height-infoBg.height)>>1 ;
			//奖励
			if(questVO.rewardsVO){
				var rewads:RewardsPanel = new RewardsPanel(questVO.rewardsVO , 500);
				container.addChild( rewads );
				questVO.isReceived = true ;
			}
		}
		
		
		
		
		
		
		
		//======================================
		
		private function onCloseHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			mouseChildren = false ;
			TweenLite.to(this,0.3,{x:x+200 , ease:Back.easeIn , onComplete:tweenComplete});
			SoundManager.instance.playSoundPopupShow();
		}
		
		private function tweenComplete():void{
			PopUpManager.instance.removeCurrentPopup();
		}
		
		override protected function removed():void
		{
			LeftBar.instance.removeQuestItemRenderer( questVO.qid); //任务icon列表刷新
			questVO = null ;
			btnClose.removeEventListener(MouseEvent.CLICK , onCloseHandler );
			btnOk.removeEventListener(MouseEvent.CLICK , onCloseHandler );
			QuestModel.instance.getQuests() ; //重新获取quests
		}
	}
}