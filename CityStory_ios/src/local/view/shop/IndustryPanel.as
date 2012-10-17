package local.view.shop
{
	import flash.events.MouseEvent;
	
	import local.model.PlayerModel;
	import local.model.ShopModel;
	import local.util.GameUtil;

	public class IndustryPanel extends ShopPanel
	{
		private static var _instance:IndustryPanel;
		public static function get instance():IndustryPanel{
			if(!_instance) _instance = new IndustryPanel();
			return _instance ;
		}
		//=====================================
		
		public function IndustryPanel()
		{
			super();
			init();
		}
		
		
		private function init():void
		{
			_scroll.addScrollControll( _content , container , 3 , 20 );
			
			var itemRenders:Vector.<ShopItemRenderer> = ShopModel.instance.industryRenderers ;
			if(!itemRenders) return ;
			var len:int =itemRenders.length ;
			var render:ShopItemRenderer ;
			for( var i:int=0 ; i<len ; ++i )
			{
				render = itemRenders[i] ;
				_scroll.addItem( render );
			}
			refreshPageButton();
		}
		
		
		override protected function onItemHandler( e:MouseEvent ):void
		{
			super.onItemHandler(e);
			if(e.target is ShopItemRenderer)
			{
				var render:ShopItemRenderer = e.target as ShopItemRenderer ;
				if( checkMoney(render) && checkPop() ){
					addItemToWorld( render );
				}
			}
		}
		
		/**
		 * 判断人口 
		 * @return 
		 */		
		private function checkPop():Boolean
		{
			if( PlayerModel.instance.getCurrentPop()>= GameUtil.buildIndustryPop())
			{
				return true ;
			}
			//弹出窗口提示
			trace("当前人口：",PlayerModel.instance.getCurrentPop() , "需要人口："+GameUtil.buildIndustryPop());
			return false ;
		}
	}
}