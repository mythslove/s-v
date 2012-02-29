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
		
		private const COUNT:int = 8 ;//一页显示八个
		private var _totalPage:int ;
		private var _page:int ;
		
		public function ShopBuildingPanel()
		{
			super();
		}
		
		
		public function set dataProvider( value:Vector.<BuildingVO> ):void
		{
			_dataProvider = value ;
			_page = 0 ;
			_totalPage = 0 ;
			if(value){
				_totalPage = Math.ceil(value.length/COUNT);
			}
			showBuildingList(0);
			updatePageButton();
		}
		
		public function showBuildingList( page:int ):void
		{
			ContainerUtil.removeChildren(container);
			_page = page ;
			var render:ShopItemRenderer ;
			var col:int = 4 ;
			for( var i:int = _page ; i<_totalPage && i<_page+COUNT ; ++i )
			{
				render = new ShopItemRenderer();
				render.x = (i%col)*(render.width + 10);
				render.y = Math.floor(i/col)*(render.height+10);
				container.addChild(render);
				render.showBuilding( _dataProvider[i] );
			}
		}
		
		private function updatePageButton():void
		{
			if(_totalPage==0){
				btnNextPage.enabled=btnPrevPage.enabled=false ;
			}else{
				btnNextPage.enabled=btnPrevPage.enabled=true ;
				if(_page==_totalPage-1){
					btnNextPage.enabled = false;
				}
				if(_page==0){
					btnPrevPage.enabled = false ;
				}
			}
		}
	}
}