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
	import local.model.vos.QuestVO;
	import local.utils.PopUpManager;
	import local.views.base.BaseView;

	/**
	 * 任务进度信息窗口 
	 * @author zzhanglin
	 */	
	public class QuestInfoPopUp extends BaseView
	{
		public var txtTitle:TextField; //标题
		public var txtDec:TextField; //描述
		public var desBg:Sprite;//描述的背景
		public var btnClose:BaseButton ; //关闭按钮
		public var btnOk:BaseButton;
		public var listBg:Sprite ;//任务列表的背景
		private var container:Sprite ; //任务进度容器
		//=============================
		public var questVO:QuestVO ;
		private var _ro:GameRemote;
		public function get ro():GameRemote
		{
			if(!_ro){
				_ro = new GameRemote("");
				_ro.addEventListener(ResultEvent.RESULT , onResultHandler );
			}
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
			if(questVO.isAccept){
				init();
			}else {
				visible = false ;
				ro.getOperation("accept").send(questVO.qid);
			}
		}
		
		private function init():void
		{
			TweenLite.from(this,0.3,{x:-200 , ease:Back.easeOut });
			btnClose.addEventListener(MouseEvent.CLICK , onCloseHandler );
			btnOk.addEventListener(MouseEvent.CLICK , onCloseHandler );
			//显示详细
			txtTitle.text = questVO.title ;
			txtDec.text = questVO.info ;
			txtDec.y = desBg.y +(desBg.height-txtDec.height)>>1 ;
			var proPanel:QuestProgressPanel = new QuestProgressPanel(questVO) ;
			container.addChild(proPanel);
		}
		
		private function onResultHandler( e:ResultEvent ):void
		{
			switch( e.method)
			{
				case "accept":
					visible = true ;
					questVO = e.result as QuestVO ; //返回新的QuestVO
					init();
					break ;
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		//============关闭窗口==============================
		
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
			if(_ro){
				_ro.removeEventListener(ResultEvent.RESULT , onResultHandler );
				_ro = null ;
			}
			questVO = null ;
			btnClose.removeEventListener(MouseEvent.CLICK , onCloseHandler );
			btnOk.removeEventListener(MouseEvent.CLICK , onCloseHandler );
		}
	}
}