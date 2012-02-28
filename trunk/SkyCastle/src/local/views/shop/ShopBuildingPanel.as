package local.views.shop
{
	import bing.components.button.BaseButton;
	import bing.utils.ContainerUtil;
	
	import flash.display.Sprite;
	
	import local.model.buildings.vos.BuildingVO;
	import local.views.BaseView;

	/**
	 * 商店中的建筑面板
	 * @author zzhanglin
	 */	
	public class ShopBuildingPanel extends BaseView
	{
		public var container:Sprite;
		public var btnPrevPage:BaseButton;
		public var btnNextPage:BaseButton;
		//===================================
		
		private var _dataProvider:Vector.<BuildingVO>; 
		
		private var _totalPage:int ;
		private var _page:int ;
		
		public function ShopBuildingPanel()
		{
			super();
		}
		
		
		public function set dataProvider( value:Vector.<BuildingVO> ):void
		{
			
		}
		
		public function clear():void
		{
			_page = 0 ;
			ContainerUtil.removeChildren(container);
		}
	}
}