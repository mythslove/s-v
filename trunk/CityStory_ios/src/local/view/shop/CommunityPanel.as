package local.view.shop
{
	import flash.events.MouseEvent;
	
	import local.model.ShopModel;

	public class CommunityPanel extends ShopPanel
	{
		private static var _instance:CommunityPanel;
		public static function get instance():CommunityPanel{
			if(!_instance) _instance = new CommunityPanel();
			return _instance ;
		}
		//=====================================
		
		public function CommunityPanel()
		{
			super();
			container.y =30 ; 
			init();
		}
		
		private function init():void
		{
			scroll.addScrollControll( _content , container , 3 , 20 );
			
			var itemRenders:Vector.<ShopItemRenderer> = ShopModel.instance.communityRenderers ;
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