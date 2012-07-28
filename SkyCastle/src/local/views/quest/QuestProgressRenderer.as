package local.views.quest
{
	import bing.amf3.ResultEvent;
	import bing.components.BingComponent;
	import bing.components.button.BaseButton;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.comm.GameRemote;
	import local.model.PlayerModel;
	import local.model.QuestModel;
	import local.model.vos.QuestItemVO;
	import local.utils.GameUtil;
	import local.views.alert.CostCashAlert;
	import local.views.base.Image;

	/**
	 * 任务的进度Render
	 * @author zzhanglin
	 */	
	public class QuestProgressRenderer extends BingComponent
	{
		public var img:Sprite; //图片容器
		public var txtDes:TextField; //描述
		public var txtCount:TextField; //进度
		public var txtSkip:TextField ; //跳过此任务需要的cash
		public var btnSkip:BaseButton ; //跳过此任务的按钮
		//================================
		public var itemVO:QuestItemVO ;
		
		public function QuestProgressRenderer( itemVO:QuestItemVO)
		{
			super();
			stop();
			mouseEnabled = false ;
			this.itemVO = itemVO ;
		}
		
		override protected function addedToStage():void
		{
			txtDes.text = itemVO.title ;
			txtCount.text = itemVO.current+"/"+itemVO.sum ;
			txtSkip.text = itemVO.skipCash+"";
			var thumb:Image = new Image( "questItem"+itemVO.icon , "res/quest/"+itemVO.icon) ;
			img.addChild( thumb );
			if(itemVO.isSkipped){
				gotoAndStop(2);
			}else{
				btnSkip.addEventListener(MouseEvent.CLICK , onSkipHandler , false , 0 , true );
			}
			GameUtil.disableTextField( this );
		}
		
		private function onSkipHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			CostCashAlert.show("Are you sure to skip this item using Gem?" , itemVO.skipCash+"" , skipped );
		}
		
		private function skipped():void
		{
			if(PlayerModel.instance.me.cash<itemVO.skipCash){
				//弹出cash商店
			}else{
				var ro:GameRemote = new GameRemote("CommService");
				ro.addEventListener(ResultEvent.RESULT , onResultHandler , false , 0 , true );
				ro.getOperation( "skipQuestItem").send( itemVO.itemId );
				btnSkip.enabled = false ;
			}
		}
		
		private function onResultHandler( e:ResultEvent ):void
		{
			PlayerModel.instance.me.cash -= itemVO.skipCash ;
			this.gotoAndStop(2);
			itemVO.isSkipped = true ;
			QuestModel.instance.checkCompleteQuest();
		}
		
		override protected function removedFromStage():void
		{
			stop();
			itemVO = null ;
			if(btnSkip) btnSkip.removeEventListener(MouseEvent.CLICK , onSkipHandler);
		}
	}
}