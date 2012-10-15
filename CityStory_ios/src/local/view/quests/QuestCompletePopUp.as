package local.view.quests
{
	import local.view.base.BaseView;
	
	public class QuestCompletePopUp extends BaseView
	{
		private static var _instance:QuestCompletePopUp;
		public static function get instance():QuestCompletePopUp{
			if(!_instance) _instance = new QuestCompletePopUp();
			return _instance ;
		}
		//=====================================
	}
}