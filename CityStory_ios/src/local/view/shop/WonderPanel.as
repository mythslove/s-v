package local.view.shop
{
	import flash.events.MouseEvent;
	
	import local.model.ShopModel;
	
	public class WonderPanel extends ShopPanel
	{
		private static var _instance:WonderPanel;
		public static function get instance():WonderPanel{
			if(!_instance) _instance = new WonderPanel();
			return _instance ;
		}
		//=====================================
		
		public function WonderPanel()
		{
			super();
			container.y =30 ; 
			init();
		}
		
		private function init():void
		{
			scroll.addScrollControll( _content , container , 3 , 20 );
			
			var itemRenders:Vector.<ShopItemRenderer> = ShopModel.instance.wondersRenderers ;
			if(!itemRenders) return ;
			var len:int =itemRenders.length ;
			var render:ShopItemRenderer ;
			for( var i:int=0 ; i<len ; ++i )
			{
				render = itemRenders[i];
				scroll.addItem( render );
			}
			refreshPageButton();
		}
		
		
		override protected function onItemHandler( e:MouseEvent ):void
		{
			super.onItemHandler(e);
			if(e.target is ShopItemRenderer)
			{
				var render:ShopItemRenderer = e.target as ShopItemRenderer ;
				if( checkMoney(render)){
					addItemToWorld( render );
				}
			}
		}
	}
}