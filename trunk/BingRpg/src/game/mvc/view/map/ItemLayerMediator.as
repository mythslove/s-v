package game.mvc.view.map
{
	import bing.utils.ContainerUtil;
	
	import flash.display.DisplayObjectContainer;
	
	import game.events.ItemEvent;
	import game.mvc.base.GameMediator;
	/**
	 * 地图玩家层 
	 * @author zzhanglin
	 */	
	public class ItemLayerMediator extends GameMediator
	{
		public function get itemLayer():ItemLayer
		{
			return view as ItemLayer ;
		}
		public function ItemLayerMediator(view:DisplayObjectContainer)
		{
			super(view);
		}
		
		override public function onRegister():void
		{
			super.onRegister() ;
			
			this.addContextListener( ItemEvent.ADD_ITEM , addItemHandler );
			this.addContextListener( ItemEvent.REMOVE_ITEM , removeItemHandler );
			this.addContextListener( ItemEvent.CLEAR_ALL_ITEM , clearAllItemHandler );
		}
		
		/**
		 * 添加一个Item到场景上 
		 * @param e
		 */		
		private function addItemHandler( e:ItemEvent ):void
		{
			itemLayer.addChild( e.item );
		}
		
		/**
		 * 从场景上移除一个Item 
		 * @param e
		 */		
		private function removeItemHandler( e:ItemEvent ):void
		{
			if( itemLayer.contains( e.item))
			{
				itemLayer.removeChild( e.item );
			}
		}
		
		/**
		 * 从场景上清除所有的Item 
		 * @param e
		 */		
		private function clearAllItemHandler( e:ItemEvent ):void
		{
			ContainerUtil.removeChildren( itemLayer );
		}
	}
}