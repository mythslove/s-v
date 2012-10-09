package
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	public class ShopPageScroller extends EventDispatcher
	{
		public static const SCROLL_POSITION_CHANGE : String = "ScrollPositionChange";
		public static const SCROLL_OVER:String = "ScrollOver";
		
		private const SCROLLING_MIN_SPEED : Number = 0.20; // in pixels/ms
		private const SCROLLING_MAX_SPEED : Number = 4; // in pixels/ms
		
		private var _container:Sprite ;
		private var _mask:Shape ;
		private var _items:Vector.<DisplayObject> ;
		private var _containerViewport:Rectangle ;
		private var _pageCap:int ;
		private var _itemCap:int ;
		private var _perCount:int ;
		
		/**
		 *  
		 * @param container
		 * @param items 所有的items
		 * @param perCount 每页有几个item
		 * @param pageCap 每页的间隔
		 * @param itemCap 每个item的间隔
		 * @param containerViewport
		 * 
		 */		
		public function addScrollControll(container:Sprite , 
															items:Vector.<DisplayObject> , 
															perCount:int ,
															pageCap:int ,
															itemCap:int ,
															containerViewport : Rectangle = null):void
		{
			this._container = container ;
			this._items = items ;
			this._pageCap = pageCap ;
			this._itemCap = itemCap ;
			this._containerViewport = containerViewport ;
			
			addMask();
			
			addItems();
			
		}
		
		private function addMask():void
		{
			_mask = new Shape();
			_mask.graphics.beginFill(0);
			if(!_containerViewport){
				_containerViewport = new Rectangle(0,0,_container.width,_container.height);
			}
			_mask.graphics.drawRect(_containerViewport.x,_containerViewport.y,_containerViewport.width,_containerViewport.height);
			_mask.graphics.endFill();
			_container.addChild(_mask);
			_container.mask = _mask ;
		}
		
		private function addItems():void
		{
			var len:int = _items.length ;
			for( var i:int = 0 ; i<len ; ++i )
			{
				var item:DisplayObject = _items[i] ;
			}
		}
	}
}