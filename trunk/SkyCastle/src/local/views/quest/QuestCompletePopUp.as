package local.views.quest
{
	import bing.components.button.BaseButton;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.model.vos.QuestVO;
	import local.utils.PopUpManager;
	import local.views.base.BaseView;

	/**
	 * 任务完成弹出窗口 
	 * @author zzhanglin
	 */	
	public class QuestCompletePopUp extends BaseView
	{
		public var rewardsBg:Sprite;
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
			this.questVO = vo ;
			rewardsBg.mouseChildren = rewardsBg.mouseEnabled = false  ;
			infoBg.mouseChildren = infoBg.mouseEnabled = false  ;
			container.mouseChildren = container.mouseEnabled = false  ;
			txtTitle.mouseEnabled = txtCompleteInfo.mouseEnabled = false ;
		}
		
		override protected function added():void
		{
			TweenLite.from(this,0.3,{x:-200 , ease:Back.easeOut });
			btnClose.addEventListener(MouseEvent.CLICK , onCloseHandler );
			btnOk.addEventListener(MouseEvent.CLICK , onCloseHandler );
		}
		
		
		
		
		
		
		
		//======================================
		
		private function onCloseHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			mouseChildren = false ;
			TweenLite.to(this,0.3,{x:x+200 , ease:Back.easeIn , onComplete:tweenComplete});
		}
		
		private function tweenComplete():void{
			PopUpManager.instance.removeCurrentPopup();
		}
		
		override protected function removed():void
		{
			questVO = null ;
			btnClose.removeEventListener(MouseEvent.CLICK , onCloseHandler );
			btnOk.removeEventListener(MouseEvent.CLICK , onCloseHandler );
		}
	}
}