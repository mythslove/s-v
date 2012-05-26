package local.views.quest
{
	import flash.display.Sprite;
	
	import local.model.vos.QuestVO;

	/**
	 * 任务的进度面板 
	 * @author zzhanglin
	 */	
	public class QuestProgressPanel extends Sprite
	{
		public var questVO:QuestVO ;
		
		public function QuestProgressPanel( questVO:QuestVO )
		{
			super();
			mouseEnabled = false; 
			this.questVO = questVO ;
			init();
		}
		
		private function init():void
		{
			var items:Array = questVO.items ;
			if(items)
			{
				var len:int = items.length ;
				var render:QuestProgressRenderer ;
				for( var i:int = 0 ; i<len ; ++i)
				{
					render = new QuestProgressRenderer(items[i]);
					render.y = render.height*i + 10 ;
					addChild(render);
				}
			}
		}
	}
}