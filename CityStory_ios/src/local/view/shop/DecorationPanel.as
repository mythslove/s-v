package local.view.shop
{
	import flash.events.MouseEvent;
	
	import local.model.ShopModel;
	
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
			var itemRenders:Vector.<ShopItemRenderer> = ShopModel.instance.decorsRenderers ;
			if(!itemRenders) return ;
			var len:int =itemRenders.length , cop:int=5 ;
			var render:ShopItemRenderer ;
			for( var i:int=0 ; i<len ; ++i )
			{
				render = itemRenders[i] ;
				render.x = (render.width+cop)*i ;
				_content.addChild( render );
			}
			_scroll.addScrollControll( _content , container);
			container.addChild(_content);
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