package local.views.quest
{
	import bing.amf3.ResultEvent;
	import bing.components.button.BaseButton;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.comm.GameRemote;
	import local.comm.GameSetting;
	import local.model.PlayerModel;
	import local.model.QuestModel;
	import local.model.vos.QuestVO;
	import local.utils.GameUtil;
	import local.utils.PopUpManager;
	import local.utils.SoundManager;
	import local.views.base.BaseView;

	/**
	 * 任务进度信息窗口 
	 * @author zzhanglin
	 */	
	public class QuestInfoPopUp extends BaseView
	{
		public var txtTitle:TextField; //标题
		public var txtDes:TextField; //描述
		public var txtRequireRank:TextField ; //要求的rank值
		public var txtButton:TextField ; //按钮上面的文字
		public var desBg:Sprite;//描述的背景
		public var btnClose:BaseButton ; //关闭按钮
		public var btnOk:BaseButton;
		public var btnAllQuests:BaseButton ; //查看所有的任务按钮 
		public var listBg:Sprite ;//任务列表的背景
		public var container:Sprite ; //任务进度容器
		//=============================
		public var questVO:QuestVO ;
		private var _ro:GameRemote;
		public function get ro():GameRemote
		{
			if(!_ro){
				_ro = new GameRemote("CommService");
				_ro.addEventListener(ResultEvent.RESULT , onResultHandler );
			}
			return _ro ;
		}
		
		public function QuestInfoPopUp( vo:QuestVO )
		{
			super();
			x = GameSetting.SCREEN_WIDTH>>1;
			y = GameSetting.SCREEN_HEIGHT>>1;
			this.questVO = vo ;
		}
		
		override protected function added():void
		{
			GameUtil.disableTextField(this);
			
			TweenLite.from(this,0.3,{x:-200 , ease:Back.easeOut });
			SoundManager.instance.playSoundSpecialPopShow();
			btnClose.addEventListener(MouseEvent.CLICK , onCloseHandler );
			btnOk.addEventListener(MouseEvent.CLICK , onCloseHandler );
			//显示详细
			txtTitle.text = questVO.title ;
			txtDes.text = questVO.describe ;
			txtDes.y += (desBg.height-txtDes.textHeight)>>1 ;
			var proPanel:QuestProgressPanel = new QuestProgressPanel(questVO) ;
			container.addChild(proPanel);
			txtRequireRank.text = "Require Rank "+questVO.requireRank+" !" ;
			
			txtRequireRank.visible = false ;
			if(questVO.isAccept){
				txtButton.text = "OK";
			}else {
				txtButton.text = "Accept";
				if(questVO.requireRank>PlayerModel.instance.me.rank){
					txtRequireRank.visible = true ;
					btnOk.enabled = false ;
				}
			}
			btnAllQuests.addEventListener(MouseEvent.CLICK , onAllQuestHandler );
			btnOk.addEventListener(MouseEvent.CLICK , onBtnOkHandler);
		}
		
		private function onBtnOkHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			if( txtButton.text == "Accept"){
				ro.getOperation("acceptQuest").send(questVO.qid);
				txtRequireRank.text = "Loading...";
				mouseChildren = false ;
			}
			else 
				onCloseHandler( e ) ;
		}
		
		private function onAllQuestHandler( e:MouseEvent ):void
		{
			e.stopPropagation() ;
			//打开任务列表窗口
		}
		
		private function onResultHandler( e:ResultEvent ):void
		{
			switch( e.method)
			{
				case "acceptQuest":
					mouseChildren = true ;
					btnOk.enabled = true ;
					txtButton.text = "OK";
					txtRequireRank.visible = false ;
					questVO = e.result as QuestVO ; //返回新的QuestVO
					questVO.init(); //初始化任务
					QuestModel.instance.checkCompleteQuest() ; //判断是没有已经完成了的quest
					break ;
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		//============关闭窗口==============================
		
		private function onCloseHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			mouseChildren = false ;
			TweenLite.to(this,0.3,{x:x+200 , ease:Back.easeIn , onComplete:tweenComplete});
			SoundManager.instance.playSoundClick();
		}
		
		private function tweenComplete():void{
			PopUpManager.instance.removeCurrentPopup();
		}
		
		override protected function removed():void
		{
			if(_ro){
				_ro.removeEventListener(ResultEvent.RESULT , onResultHandler );
				_ro = null ;
			}
			questVO = null ;
			btnClose.removeEventListener(MouseEvent.CLICK , onCloseHandler );
			btnOk.removeEventListener(MouseEvent.CLICK , onBtnOkHandler );
			btnAllQuests.removeEventListener(MouseEvent.CLICK , onAllQuestHandler );
		}
	}
}