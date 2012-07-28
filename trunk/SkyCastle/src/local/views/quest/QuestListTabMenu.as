package local.views.quest
{
	import bing.components.button.BaseToggleButton;
	import bing.components.button.ToggleBar;
	
	/**
	 * active , completed 
	 * @author zzhanglin
	 */	
	public class QuestListTabMenu extends ToggleBar
	{
		public var btnActive:BaseToggleButton ;
		public var btnCompleted:BaseToggleButton ;
		//==============================
		
		public function QuestListTabMenu()
		{
			super();
		}
	}
}