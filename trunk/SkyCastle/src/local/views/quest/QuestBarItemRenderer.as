package local.views.quest
{
	import flash.events.MouseEvent;
	
	import local.model.vos.QuestVO;
	import local.utils.PopUpManager;
	import local.views.base.BaseView;
	import local.views.base.Image;
	import local.views.tooltip.GameToolTip;

	/**
	 * 主窗口界面上的任务icon 
	 * @author zhouzhanglin
	 */	
	public class QuestBarItemRenderer extends BaseView
	{
		public var questVO:QuestVO;
		private var _newFlag:QuestBarNewFlag ;
		
		public function QuestBarItemRenderer( vo:QuestVO )
		{
			super();
			buttonMode = true ;
			mouseChildren = false ;
			this.questVO = vo ;
		}
		
		override protected function added():void
		{
			if(!questVO.isAccept){
				_newFlag = new QuestBarNewFlag();
				addChild(_newFlag);
			}
			GameToolTip.instance.register( this , stage , "QUEST:"+questVO.title );
			var thumb:Image = new Image( "quest"+questVO.icon , "res/quest/"+questVO.icon );
			addChild(thumb);
			addEventListener(MouseEvent.CLICK , onClickHandler );
		}
		
		private function onClickHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			if(_newFlag){
				_newFlag.stop();
				removeChild(_newFlag);
				_newFlag = null ;
			}
			var info:QuestInfoPopUp = new QuestInfoPopUp( questVO );
			PopUpManager.instance.addQueuePopUp( info );
		}
		
		override protected function removed():void
		{
			GameToolTip.instance.unRegister( this );
			if(_newFlag){
				_newFlag.stop();
				removeChild(_newFlag);
				_newFlag = null ;
			}
			questVO = null ;
			removeEventListener(MouseEvent.CLICK , onClickHandler );
		}
	}
}