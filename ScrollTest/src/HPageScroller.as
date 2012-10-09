package
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	public class HPageScroller extends EventDispatcher
	{
		public static const SCROLL_POSITION_CHANGE : String = "ScrollPositionChange";
		public static const SCROLL_OVER:String = "ScrollOver";
		
		private const SCROLLING_MIN_SPEED : Number = 0.20; // in pixels/ms
		private const SCROLLING_MAX_SPEED : Number = 4; // in pixels/ms
		
		private var _container:Sprite ;
		private var _mask:Shape ;
		private var _containerViewport:Rectangle ;
		private var _pageCap:int ;
		
		private var _previousFingerPosition : Number = 0;
		private var _currentFingerPosition : Number = 0;
		
		private var _totalPage:int ;
		private var _currentPage:int ; //以0开始
		private var _endPosition:Number ;
		
		public function get totalPage():int{ return _totalPage; }
		public function get currentPage():int{ return _currentPage+1; }
		
		
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
															pageCap:int ,
															containerViewport : Rectangle = null):void
		{
			this._container = container ;
			this._pageCap = pageCap ;
			this._containerViewport = containerViewport ;
			
			_totalPage = 0 ;
			_currentPage = 0 ;
			
			addMask();
			
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
		
		
		public function addPage( page:DisplayObject ):void
		{
			page.x = ( page.width+_pageCap ) * _totalPage ;
			_totalPage++ ;
			_container.addChild( page );
		}
		
		
		
		private function onMouseDown(e:MouseEvent):void
		{
			_container.mouseChildren = true  ;
			
			_previousFingerPosition = e.stageX;
			_currentFingerPosition = _previousFingerPosition;
			
			_container.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove );
			_container.addEventListener(MouseEvent.MOUSE_UP, onMouseUp );
			_container.addEventListener(MouseEvent.RELEASE_OUTSIDE, onMouseUp );
			_container.addEventListener(Event.ENTER_FRAME , onEnterFrame);
		}
		
		private function onMouseMove( e:MouseEvent ):void
		{
			if(e.buttonDown) {
				_container.mouseChildren = false  ;
				
				// Update finger position
				_currentFingerPosition = e.stageX;
			}
			
		}
		
		private function onMouseUp( e:MouseEvent ):void
		{
			_container.mouseChildren = true  ;
			_container.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_container.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_container.removeEventListener(MouseEvent.RELEASE_OUTSIDE, onMouseUp );
		}
		
		private function onEnterFrame( e:Event ):void
		{
			
		}
		
		
		public function removeScrollControll() : void
		{
			if(_mask && _mask.parent){
				_mask.parent.removeChild(_mask);
			}
			_mask = null ;
			_container.mask = null ;
			_containerViewport = null ;
			_container.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown  );
			_container=  null ;
		}
	}
}