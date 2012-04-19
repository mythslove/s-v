package local.views.storage
{
	import bing.components.button.BaseToggleButton;
	import bing.components.button.ToggleBar;

	/**
	 * 收藏箱的MenuBar 
	 * @author zzhanglin
	 * 
	 */	
	public class StorageMainTab extends ToggleBar
	{
		public var btnBuilding:BaseToggleButton;
		public var btnDecoration:BaseToggleButton;
		public var btnPlant:BaseToggleButton ;
		public var btnMaterial:BaseToggleButton;
		//====================================
		
		public function StorageMainTab()
		{
			super();
		}
	}
}