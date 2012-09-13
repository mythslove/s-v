package local.view.shop
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import local.comm.GameData;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.item.BaseBuilding;
	import local.util.BuildingFactory;
	import local.util.PopUpManager;
	import local.view.control.ScrollControllerH;
	
	public class ShopPanel extends Sprite
	{
		public var container:Sprite ;
		protected var _scroll:ScrollControllerH = new ScrollControllerH() ;
		protected var _scrollContainer:Sprite = new Sprite() ;
		
		public function ShopPanel()
		{
			super();
			container = new Sprite();
			container.x = 5 ;
			container.y = 130 ;
			container.graphics.beginFill(0,0);
			container.graphics.drawRect(0,0,830,360);
			container.graphics.endFill();
			addChild(container);
			
			_scrollContainer.addEventListener(MouseEvent.CLICK , onItemHandler );
		}
		
		protected function onItemHandler( e:MouseEvent):void
		{
			e.stopPropagation();
		}
		
		/**
		 * 将item转换成建筑，放到场景上 
		 * @param item
		 */		
		public function addItemToWorld( render:ShopItemRenderer ):void
		{
			var building:BaseBuilding = BuildingFactory.createBuildingByBaseVO( render.baseVO );
			
			GameWorld.instance.addBuildingToTopScene( building);
			GameData.villageMode=VillageMode.BUILDING_SHOP ;
			PopUpManager.instance.removeCurrentPopup();
		}
	}
}