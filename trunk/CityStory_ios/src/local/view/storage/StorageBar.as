package local.view.storage
{
	import flash.events.Event;
	
	import local.view.base.BaseView;
	
	/**
	 * 收藏箱 
	 * @author zhouzhanglin
	 */	
	public class StorageBar extends BaseView
	{
		private static var _instance:StorageBar;
		public function get instance():StorageBar{
			if(!_instance) _instance = new StorageBar();
			return _instance ;
		}
		//==================================
		public function StorageBar()
		{
			super();
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
		}
		
		override protected function removedFromStageHandler(e:Event):void
		{
			super.removedFromStageHandler(e);
		}
	}
}