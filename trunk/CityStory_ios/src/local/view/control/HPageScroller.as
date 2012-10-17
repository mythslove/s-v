package local.view.control
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	[Event(name="ScrollPositionChange", type="flash.events.Event")]
	[Event(name="ScrollOver", type="flash.events.Event")]
	public class HPageScroller extends EventDispatcher
	{
		public static const SCROLL_POSITION_CHANGE : String = "ScrollPositionChange";
		public static const SCROLL_OVER:String = "ScrollOver";
		
		public var speed:Number = 0.4 ;
		
		private var _container:Sprite ;
		private var _content:Sprite ;
		private var _mask:Shape ;
		private var _containerViewport:Rectangle ;
		
		private var _prevContainerPos:Number ;
		private var _mouseDownPos:Number;
		private var _endPos:Number ;
		private var _mouseTime:Number ;
		
		private var _perCount:int ;
		private var _itemCap:int ;
		private var _totalPage:int ;
		private var _currentPage:int ; //以0开始
		private var _endPosition:Number ;
		private var _itemNum:int ;//item的数量
		
		private var _isMouseDown:Boolean;
		
		/**
		 * 是否锁定滑动 
		 */		
		public var scrollLock:Boolean  ;
		
		public function get totalPage():int{ return _totalPage+1 ; }
		public function get currentPage():int{ return _currentPage+1; }
		private function set endPos( value:Number ):void
		{
			if(value>0){
				_endPos= 0 ;
			}else if(value<-_totalPage*_containerViewport.width){
				_endPos = -_totalPage*_containerViewport.width ;
			}else{
				_endPos = value ;
			}
		}
		
		/**
		 * 
		 * @param content
		 * @param container
		 * @param pageCap 每页的间隔
		 * @param itemCap item的间隔
		 * @param containerViewport
		 */		
		public function addScrollControll( content:Sprite ,
											container:Sprite , 
											perCount:int , 
											itemCap:int =5 ,
											containerViewport : Rectangle = null):void
		{
			this._content = content ;
			this._container = container ;
			this._containerViewport = containerViewport ;
			this._perCount = perCount ;
			this._itemCap = itemCap ;
			
			_itemNum = 0 ;
			_totalPage = 0 ;
			_currentPage = 0 ;
			_prevContainerPos = 0;
			
			addMask();
			_container.addEventListener(MouseEvent.MOUSE_DOWN, onMouseHandler);
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
		
		
		public function addItem( item:DisplayObject ):void
		{
			if(_itemNum>0 && _itemNum%_perCount==0){
				++_totalPage;
			}
			
			var pageOffset:Number = _containerViewport.width*_totalPage ;
			var initOffset:int = (_containerViewport.width-item.width*_perCount-_itemCap*(_perCount-1) )*0.5 ;
			
			item.x = pageOffset  + initOffset + (_itemNum%_perCount)*(item.width + _itemCap)   ;
			checkVisible( item );
			_content.addChild(item);
			
			++_itemNum ;
		}
		
		private function checkVisible( item :DisplayObject):void
		{
			var position:Number = item.x+_content.x ;
			if(position<-_containerViewport.width || position>_containerViewport.width*2 ){
				item.visible = false ;
			}else{
				item.visible=true;
			}
		}
		
		private function onMouseHandler( e:MouseEvent ):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					_isMouseDown = true ;
					_container.mouseChildren = true  ;
					_mouseTime  = getTimer() ;
					_mouseDownPos = e.stageX ;
					_prevContainerPos = _content.x ;
					_container.addEventListener(MouseEvent.MOUSE_MOVE, onMouseHandler );
					_container.addEventListener(MouseEvent.MOUSE_UP, onMouseHandler );
					_container.addEventListener(MouseEvent.ROLL_OUT, onMouseHandler );
					_container.addEventListener(MouseEvent.RELEASE_OUTSIDE, onMouseHandler );
					break ;
				case MouseEvent.MOUSE_MOVE:
					if(!scrollLock){
						if(e.buttonDown) {
							_container.mouseChildren = false  ;
							endPos = _prevContainerPos +  e.stageX-_mouseDownPos ;
							if(!_container.hasEventListener(Event.ENTER_FRAME)){
								_container.addEventListener(Event.ENTER_FRAME , onEnterFrame);
							}
							this.dispatchEvent( new Event(SCROLL_POSITION_CHANGE));
							break ;
						}
					}
				default:
					_container.mouseChildren = true  ;
					_isMouseDown = false ;
					_container.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseHandler);
					_container.removeEventListener(MouseEvent.MOUSE_UP, onMouseHandler);
					_container.removeEventListener(MouseEvent.MOUSE_OUT, onMouseHandler);
					_container.removeEventListener(MouseEvent.ROLL_OUT, onMouseHandler );
					_container.removeEventListener(MouseEvent.RELEASE_OUTSIDE, onMouseHandler );
					//判断翻页
					var cha:Number = _mouseDownPos-e.stageX ;
					var timeCha:Number = getTimer()-_mouseTime ;
					if(cha>_containerViewport.width*_container.root.scaleX*0.4 || (cha>0 && timeCha<200 )){ //向右翻页
						nextPage();
					}else if( cha<-_containerViewport.width*_container.root.scaleX*0.4 || (cha<0 && timeCha<200 ) ){
						prevPage();
					}else{
						endPos = _prevContainerPos ;
					}
					this.dispatchEvent( new Event(SCROLL_POSITION_CHANGE));
					if(!_container.hasEventListener(Event.ENTER_FRAME)){
						_container.addEventListener(Event.ENTER_FRAME , onEnterFrame);
					}
					break ;
			}
		}
		
		
		private function onEnterFrame( e:Event ):void
		{
			if( Math.abs(_content.x -_endPos)>3 ){
				_content.x  += (_endPos-_content.x)*speed ;
			}else{
				_content.x = _endPos ;
				for( var i:int = 0 ; i<_content.numChildren ; ++i){
					checkVisible( _content.getChildAt(i) );
				}
				_container.removeEventListener(Event.ENTER_FRAME , onEnterFrame);
				if(!_isMouseDown) this.dispatchEvent( new Event(SCROLL_OVER));
			}
		}
		
		public function nextPage():void
		{
			if(hasNextPage())  ++_currentPage ;
			endPos = -_currentPage*_containerViewport.width ;
			this.dispatchEvent( new Event(SCROLL_POSITION_CHANGE));
			_container.addEventListener(Event.ENTER_FRAME , onEnterFrame);
			
		}
		
		public function prevPage():void
		{
			if( hasPrevPage() ) --_currentPage  ;
			endPos = -_currentPage*_containerViewport.width ;
			this.dispatchEvent( new Event(SCROLL_POSITION_CHANGE));
			_container.addEventListener(Event.ENTER_FRAME , onEnterFrame);
		}
		
		public function hasPrevPage():Boolean
		{
			return _currentPage>0 ;
		}
		
		public function hasNextPage():Boolean
		{
			return _currentPage<_totalPage ;
		}
		
		public function scrollToPage( page:int , animation:Boolean ):void
		{
			page-=1;
			if(page<0) page=0 ;
			else if(page>=_totalPage) page = _totalPage ;
			_currentPage=page ;
			if(animation){
				for( var i:int = 0 ; i<_content.numChildren ; ++i){
					_content.getChildAt(i).visible = true ;
				}
				endPos = -_currentPage*_containerViewport.width ;
				this.dispatchEvent( new Event(SCROLL_POSITION_CHANGE));
				_container.addEventListener(Event.ENTER_FRAME , onEnterFrame);
			}else{
				_content.x = -_currentPage*_containerViewport.width;
				for( i = 0 ; i<_content.numChildren ; ++i){
					checkVisible( _content.getChildAt(i) );
				}
				_container.mouseChildren = true  ;
				_container.mouseEnabled = true ;
				_container.removeEventListener(Event.ENTER_FRAME , onEnterFrame);
				this.dispatchEvent( new Event(SCROLL_OVER));
			}
		}
		
		public function scrollToItem( item:DisplayObject , animation:Boolean  ):void
		{
			if(item.parent==_content){
				var index:int = _content.getChildIndex(item);
				scrollToPage( 1+(index/_perCount)>>0  , animation);
			}
		}
		
		public function removeScrollControll() : void
		{
			if(_mask && _mask.parent){
				_mask.parent.removeChild(_mask);
			}
			_mask = null ;
			_containerViewport = null ;
			if(_container){
				_container.mask = null ;
				_container.mouseChildren = true  ;
				_container.removeEventListener(Event.ENTER_FRAME , onEnterFrame);
				_container.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseHandler);
				_container.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseHandler);
				_container.removeEventListener(MouseEvent.MOUSE_UP, onMouseHandler);
				_container.removeEventListener(MouseEvent.ROLL_OUT, onMouseHandler );
				_container.removeEventListener(MouseEvent.RELEASE_OUTSIDE, onMouseHandler );
				_container=  null ;
			}
			_content =  null ;
		}
	}
}