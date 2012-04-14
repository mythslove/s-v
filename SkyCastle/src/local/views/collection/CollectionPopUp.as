package local.views.collection
{
	import bing.components.button.BaseButton;
	import bing.components.button.BaseToggleButton;
	
	import flash.display.Sprite;
	
	import local.views.BaseView;
	/**
	 * 所有收集的弹出窗口 
	 * @author zzhanglin
	 */	
	public class CollectionPopUp extends BaseView
	{
		public var btnClose:BaseButton;
		public var btnPrevPage:BaseToggleButton;
		public var btnNextPage:BaseToggleButton;
		public var container:Sprite ;
//		public var menuBar
			
		public function CollectionPopUp()
		{
			super();
		}
	}
}