package local.view.shop
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import local.comm.GameData;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.item.BaseBuilding;
	import local.model.ShopModel;
	import local.util.BuildingFactory;
	import local.util.PopUpManager;
	
	public class DecorationPanel extends ShopPanel
	{
		private static var _instance:DecorationPanel;
		public static function get instance():DecorationPanel{
			if(!_instance) _instance = new DecorationPanel();
			return _instance ;
		}
		//=====================================
		
		public function DecorationPanel()
		{
			super();
			init();
		}
		
		private function init():void
		{
			var decorsRenderers:Vector.<ShopItemRenderer> = ShopModel.instance.decorsRenderers ;
			if(!decorsRenderers) return ;
			var len:int =decorsRenderers.length , cop:int=5 ;
			var render:ShopItemRenderer ;
			for( var i:int=0 ; i<len ; ++i )
			{
				render = decorsRenderers[i] ;
				render.x = (render.width+cop)*i ;
				_scrollContainer.addChild( render );
			}
			_scroll.addScrollControll( _scrollContainer , container , new Rectangle(0,0,container.width,container.height));
			container.addChild(_scrollContainer);
		}
		
		
		override protected function onItemHandler( e:MouseEvent ):void
		{
			super.onItemHandler(e);
			if(e.target is ShopItemRenderer)
			{
				var render:ShopItemRenderer = e.target as ShopItemRenderer ;
				addItemToWorld( render );
			}
		}
	}
}