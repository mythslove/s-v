package local.views.quest
{
	import local.model.vos.QuestVO;
	import local.views.base.BaseView;

	/**
	 * 主窗口界面上的任务icon 
	 * @author zhouzhanglin
	 */	
	public class QuestBarItemRenderer extends BaseView
	{
		public var questVO:QuestVO;
		
		public function QuestBarItemRenderer( vo:QuestVO )
		{
			super();
			this.questVO = vo ;
		}
		
		override protected function removed():void
		{
			questVO = null ;
		}
	}
}