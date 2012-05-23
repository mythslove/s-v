package local.views.quest
{
	import flash.display.MovieClip;
	
	import local.model.vos.QuestItemVO;

	/**
	 * 任务的进度Render
	 * @author zzhanglin
	 */	
	public class QuestProgressRenderer extends MovieClip
	{
		public var itemVO:QuestItemVO ;
		
		public function QuestProgressRenderer( itemVO:QuestItemVO)
		{
			super();
			stop();
			this.itemVO = itemVO ;
		}
		
		
	}
}