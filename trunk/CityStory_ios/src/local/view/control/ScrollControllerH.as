package local.view.control
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class ScrollControllerH extends EventDispatcher
	{
		/**
		 * Event dispatched every time the scroll position changes.
		 * Read <code>scrollPosition</code> to know the current scroll position.
		 * 
		 * @see #scrollPosition
		 */
		public static const SCROLL_POSITION_CHANGE : String = "ScrollPositionChange";
		
		// Toggle debug statements.
		private static const DEBUG : Boolean = false ;
		
		// Scrolling parameters
		private static const SCROLLING_MIN_AMPLITUDE : Number = 2; // in pixels
		private static const SCROLLING_MIN_SPEED : Number = 0.20; // in pixels/ms
		private static const SCROLLING_MAX_SPEED : Number = 4; // in pixels/ms
		private static const FREE_SCROLLING_FRICTION_COEF : Number = 0.002;
		private static const BOUNCING_FRICTION_COEF : Number = 3;
		private static const BOUNCING_SPRING_RATE : Number = 0.03;
		private static const BOUNCING_FINGER_SLOW_DOWN_COEF : Number = 0.5;
		private static const FORCED_ANIMATED_SCROLLING_MIN_DURATION : Number = 250; // in ms
		private static const FORCED_ANIMATED_SCROLLING_MAX_SPEED : Number = 8; // in pixels/ms
		
		// Scroll bar appearance
		private static const SCROLLBAR_HEIGHT : Number = 10;
		private static const SCROLLBAR_MIN_WIDTH_WHEN_FREE : Number = 100;
		private static const SCROLLBAR_MIN_WIDTH_WHEN_BOUNCING : Number = 10;
		private static const SCROLLBAR_CORNER_RADIUS : Number = 10;
		private static const SCROLLBAR_BOTTOM_MARGIN : Number = 2;
		private static const SCROLLBAR_COLOR : uint = 0x000000;
		private static const SCROLLBAR_ALPHA : Number = 0.4;
		private static const SCROLLBAR_FADEOUT_DELAY : Number = 250; // in ms
		
		
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									  PUBLIC API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		/**
		 * Add scroll logic to a given view.
		 * 
		 * @param content The content that should be scrollable.
		 * @param container The container on which we will listen to mouse events.
		 * @param containerViewport A rectangle (in container coordinates) outside of which the
		 * content should be masked. The scroll bar will be displayed on the right side of the
		 * container viewport. If null, we default to the container bounds.
		 * @param contentRect A rectangle (in content coordinates) outside of which the scrolling
		 * shouldn't go. If null, the whole content will be scrollable.
		 */
		public function addScrollControll( content : DisplayObject,
										   container : DisplayObjectContainer,
										   containerViewport : Rectangle = null,
										   contentRect : Rectangle = null ) : void
		{
			if (_content || _container)
			{
				throw new Error("ScrollController - This controller is already in use.");
			}
			
			if (!content || !container)
			{
				throw new Error("ScrollController - content and container can't be null.");
			}
			
			// Save the parameters
			_container = container;
			_content = content;
			
			// Setup content rect
			setContentRect(contentRect);
			
			// Setup container viewport
			this.containerViewport = containerViewport;
			
			// Initialize the scroll bar
			initScrollBar();
			
			// Start listening to touch events
			_container.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown  );
		}
		
		/** Remove scroll logic of this controller. */
		public function removeScrollControll() : void
		{
			if (_content)
				_content.scrollRect = null;
			
			if (_container)
			{
				_container.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				_container.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//				_container.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				_container.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				_container.removeEventListener(MouseEvent.RELEASE_OUTSIDE, onMouseUp);
				_container.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			
			scrollBarFadeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onScrollBarFadeOutTimerComplete);
			_scrollBarFadeOutTimer = null ;
			
			if (_scrollBar && _container && _container.contains(_scrollBar))
				_container.removeChild(_scrollBar);
			
			_content = null;
			_container = null;
			_scrollBar = null;
			
			_containerViewport = null;
			_contentRect = null;
		}
		
		/**
		 * Scroll to the top of the scrollable area.
		 * 
		 * @param animated If true, the scrolling will be animated at the maximum scrolling speed.
		 * If false, the scrolling will happen instantely.
		 * 
		 * @see #scrollTo() 
		 */
		public function scrollToLeft( animated : Boolean = false ) : void
		{
			scrollTo(contentRect.left, animated);
		}
		
		/**
		 * Scroll to a given position (in Y content coordinate).
		 * 
		 * @param animated If true, the scrolling will be animated at the maximum scrolling speed.
		 * If false, the scrolling will happen instantely. 
		 * 
		 * @see #scrollToTop()
		 */
		public function scrollTo( position : Number, animated : Boolean = false ) : void
		{
			if (animated)
			{
				_forcedAnimatedScrollingTarget = position;
				_forcedAnimatedScrollingSpeed = Math.min(FORCED_ANIMATED_SCROLLING_MAX_SPEED, Math.abs((position - scrollPosition) / FORCED_ANIMATED_SCROLLING_MIN_DURATION));
				_forcedAnimatedScrolling = true;
				_timeOfLastFrame = getTimer();
				_container.addEventListener(Event.ENTER_FRAME, onEnterFrame );
			}
			else if (_content && _content.scrollRect)
			{
				var scrollRect:Rectangle = _content.scrollRect;
				scrollRect.x = position;
				_content.scrollRect = scrollRect;
				_previousScrollPositions['t-1'] = _previousScrollPositions['t-2'] = scrollPosition;
				updateScrollBar();
			}
		}
		
		/** The current scroll position (in X content coordinate). */
		public function get scrollPosition() : Number
		{
			return _content && _content.scrollRect ? _content.scrollRect.left : 0;
		}
		
		/** Indicates if the user is touching the scrolling area at the moment. */
		public function get touchingScreen() : Boolean
		{
			return _touchingScreen;
		}
		
		/** The current scrolling speed (in pixel/ms in content coordinates). */
		public function get speed() : Number
		{
			return _speed;
		}
		
		/** The initial bounds of the content in its own coordinates system. */
		public function get contentBounds() : Rectangle
		{
			if (!_content)
				return null;
			
			var originalWidthOnStage : Number = _content.transform.pixelBounds.width; 
			var originalWidthOnContent : Number = _content.globalToLocal(new Point(originalWidthOnStage, 0)).x - _content.globalToLocal(new Point()).x;
			
			var originalHeightOnStage : Number = _content.transform.pixelBounds.height;
			var originalHeightOnContent : Number = _content.globalToLocal(new Point( 0, originalHeightOnStage)).y - _content.globalToLocal(new Point()).y;
			
			return new Rectangle(0, 0, int(originalWidthOnContent), int(originalHeightOnContent));
		}
		
		/** A rectangle (in content coordinates) outside of which the scrolling won't go. */
		public function get contentRect() : Rectangle
		{
			if (!_content)
				return null;
			
			return _contentRect ? _contentRect : contentBounds;
		}
		
		/**
		 * Set the <code>contentRect</code> property.
		 * 
		 * @param rect The desired scrollable area.
		 * @param animated If true, and the current scrolling position is out of the new rectangle,
		 * we will animate a scrolling movement to get back in the new rectangle. If false, the
		 * scrolling movement happens instantly.
		 */
		public function setContentRect( rect : Rectangle, animated : Boolean = false ) : void
		{
			var oldRect:Rectangle = _contentRect;
			
			// Content rect accept only integer values
			if (rect)
				_contentRect = new Rectangle(int(rect.x), int(rect.y), int(rect.width), int(rect.height));
			else
				_contentRect = null;
			
			// Content rect can't be smaller than viewport
			contentRect.width = Math.max(contentRect.width, containerViewport.width);
			contentRect.height = Math.max(contentRect.height, containerViewport.height);
			
			if (animated)
			{
				_timeOfLastFrame = getTimer();
				_container.addEventListener(Event.ENTER_FRAME, onEnterFrame );
			}
			else
			{
				if (scrollPosition < contentRect.left || scrollPosition > contentRect.right)
					scrollToLeft();
			}
		}
		
		/** A rectangle (in container coordinates) outside of which the content is masked. */
		public function get containerViewport() : Rectangle
		{
			if (!_container)
				return null;
			
			if (!_containerViewport)
			{
				var bounds:Rectangle = _container.getBounds(_container);
				_containerViewport = new Rectangle(int(bounds.x), int(bounds.y), int(bounds.width), int(bounds.height));
			}
			
			return _containerViewport;
		}
		
		public function set containerViewport( viewport : Rectangle ) : void
		{
			var oldViewport:Rectangle = _containerViewport;
			
			_containerViewport = viewport ? viewport.clone() : null;
			
			// Content rect can't be smaller than viewport
			contentRect.width = Math.max(contentRect.width, containerViewport.width);
			contentRect.height = Math.max(contentRect.height, containerViewport.height);
			
			if (!_content.scrollRect || !containerViewport.equals(oldViewport))
			{
				// Update the scroll rect
				var topLeft:Point = _content.globalToLocal(_container.localToGlobal(containerViewport.topLeft));
				var bottomRight:Point = _content.globalToLocal(_container.localToGlobal(containerViewport.bottomRight));
				_content.scrollRect = new Rectangle(contentRect.x, contentRect.y, int(bottomRight.x-topLeft.x), int(bottomRight.y-topLeft.y));				
			}
		}
		
		
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									  PRIVATE VARS										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		// Managed objects
		private var _content : DisplayObject;
		private var _container : DisplayObjectContainer;
		
		// Config rectangles
		private var _contentRect : Rectangle;
		private var _containerViewport : Rectangle;
		 
		// Scroll bar
		private var _scrollBar : Shape;
		private var _scrollBarFadeOutTimer : Timer;
		
		// Flag indicating if the user is touching the screen
		private var _touchingScreen : Boolean = false;
		
		// Flag indicating that we receive a touch event between two frames, and that it has not
		// been processed yet.
		private var _pendingTouch : Boolean = false;
		
		// Last 2 finger positions (in Y stage coordinates)
		private var _previousFingerPosition : Number = 0;
		private var _currentFingerPosition : Number = 0;
		
		// Time-related vars
		private var _timeOfLastFrame : Number = 0;
		private var _timeOfLastMouseDown : Number = 0;
		
		// Current scrolling speed (in pixels/ms in content coordinates)
		private var _speed : Number = 0;
		
		// Last 2 scrolling positions (in Y content coordinates)
		private var _previousScrollPositions : Object = { 't-1':0, 't-2':0 };
		
		// Forced animated scrolling (cf. scrollTo())
		private var _forcedAnimatedScrolling : Boolean = false;
		private var _forcedAnimatedScrollingSpeed : Number = 0;
		private var _forcedAnimatedScrollingTarget : Number = 0;
		
		
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 								  PRIVATE FUNCTIONS										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		/** Create the scroll bar and add it to the display list */
		private function initScrollBar() : void
		{
			_scrollBar = new Shape();
			_scrollBar.cacheAsBitmap = true;
			updateScrollBar();
			_scrollBar.visible = false ;
		}
		
		/** Redraw the scroll bar with a new height (can't use scaling because of the rounded corners) */
		private function set scrollBarWidth( value : Number ) : void
		{
			var currentAlpha:Number = _scrollBar.alpha;
			_scrollBar.transform = _content.transform;
			_scrollBar.alpha = currentAlpha;
			_scrollBar.graphics.clear();
			_scrollBar.graphics.beginFill(SCROLLBAR_COLOR, SCROLLBAR_ALPHA);
			_scrollBar.graphics.drawRoundRect(0, 0, value, SCROLLBAR_HEIGHT, SCROLLBAR_CORNER_RADIUS, SCROLLBAR_CORNER_RADIUS);
			_scrollBar.graphics.endFill();
		}
		
		/**
		 * Update the size and position of the scroll bar depending on the current state of the
		 * controller.
		 */
		private function updateScrollBar() : void
		{
			// Check if the scroll bar is on the display list. If not, add it.
			// We do it at every update because it is added on the container, which might clean its
			// children without us knowing.
			if (!_container.contains(_scrollBar))
				_container.addChild(_scrollBar);
			
			// If the content is smaller than the container, we hide the scroll bar
			if (contentRect.width <= _content.scrollRect.width)
			{
				_scrollBar.visible = false;
				return;
			}
			else
				_scrollBar.visible = true;
			
			// Same as scrolling relative position, but constrained between 0 and 1 because the scroll bar
			// has to stay within the container viewport.
			var scrollBarRelativePosition:Number = Math.min(1, Math.max(0, scrollingRelativePosition));
			
			// Compute new scroll bar height
			var newScrollBarWidth:Number = Math.max(SCROLLBAR_MIN_WIDTH_WHEN_FREE, _content.scrollRect.width * (_content.scrollRect.width / contentRect.width));
			
			// Absolute number of pixels currently in the bounce area (0 if we are not bouncing).
			// Used to reduce the height of the scroll bar when bouncing.
			var bounceAbsoluteWidth:Number = 0;
			if (bouncingAboveContent)
				bounceAbsoluteWidth = _content.scrollRect.width * Math.abs(scrollingRelativePosition);
			else if (bouncingUnderContent)
				bounceAbsoluteWidth = _content.scrollRect.width * (scrollingRelativePosition - 1);
			if (bounceAbsoluteWidth)
				newScrollBarWidth = Math.max(SCROLLBAR_MIN_WIDTH_WHEN_BOUNCING, newScrollBarWidth - bounceAbsoluteWidth);
			
			// Apply new scroll bar height (redraws the scroll bar)
			scrollBarWidth = newScrollBarWidth;
			
			// Update scroll bar position
			_scrollBar.x = _containerViewport.left + (_containerViewport.width - newScrollBarWidth*_scrollBar.scaleX) * scrollBarRelativePosition;
			_scrollBar.y = containerViewport.bottom - _scrollBar.height - SCROLLBAR_BOTTOM_MARGIN;
		}
		
		/**
		 * Timer used to fade out the scroll bar after a given delay when no scrolling is
		 * happening. When the speed reaches zero in the content area, the timer starts.
		 * When the timer fires, the fade out animation starts. If the user starts scrolling,
		 * the timer is reset.
		 */
		private function get scrollBarFadeOutTimer() : Timer
		{
			// Lazy creation
			if (!_scrollBarFadeOutTimer)
			{
				_scrollBarFadeOutTimer = new Timer(SCROLLBAR_FADEOUT_DELAY, 1);
				_scrollBarFadeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onScrollBarFadeOutTimerComplete );
			}
			
			return _scrollBarFadeOutTimer;
		}
		
		/** Display the scroll bar and cancel any fade out animation. */
		private function showScrollBar() : void
		{
			if (!_scrollBar)
				return;
			
			// Reset the fade out timer
			scrollBarFadeOutTimer.reset();
			
			// Stop the fade out action if started
			_scrollBar.removeEventListener(Event.ENTER_FRAME, fadeOutScrollBar);
			
			// Show the scroll bar
			_scrollBar.alpha = 1;
		}
		
		/**
		 * Start the fade out timer to hide the scroll bar after a given delay.
		 * 
		 * @see #scrollBarFadeOutTimer()
		 */
		private function hideScrollBar() : void
		{
			if (!_scrollBar)
				return;
			
			// Start the fade out timer
			scrollBarFadeOutTimer.start();
		}
		
		/**
		 * Scroll bar fade out animation. This function is called every frame while the scroll bar
		 * fades out.
		 */
		private function fadeOutScrollBar( event : Event ) : void
		{
			if (!_scrollBar)
				return;
			
			// Decrease the scroll bar alpha
			_scrollBar.alpha = Math.max(0, _scrollBar.alpha - 0.2);
			
			// Stop the fade out if finished
			if (_scrollBar.alpha == 0)
				_scrollBar.removeEventListener(Event.ENTER_FRAME, fadeOutScrollBar);
		}
		
		/**
		 * Follow the finger when touching the screen.
		 * 
		 * @param deltaTime The time (in seconds) since the last frame
		 */
		private function manageFingerScrolling( deltaTime : Number ) : void
		{
			// DEBUG INFO
			if (DEBUG)
			{
				trace('---- Start managing finger scrolling');
			}
			
			// Compute the scrolling amplitude
			var deltaX:Number = _content.globalToLocal(new Point(_previousFingerPosition , 0 )).x - _content.globalToLocal(new Point( _currentFingerPosition , 0 )).x;

			if (!scrollingWithinContentArea) deltaX *= BOUNCING_FINGER_SLOW_DOWN_COEF;
			
			// Apply the scrolling movement
			moveContentFromDelta(deltaX, deltaTime);
			
			// Save the finger position
			_previousFingerPosition = _currentFingerPosition;
			
			// Indicate that finger touch has been processed
			_pendingTouch = false;
			
			// DEBUG INFO
			if (DEBUG)
			{
				trace('------ _currentFingerPosition = ' + _currentFingerPosition + ' | speed = ' + speed + ' | deltaY = ' + deltaX + ' | deltaTime = ' + deltaTime);
				trace('---- Stop managing finger scrolling');
			}
		}
		
		/**
		 * Apply physics laws when scrolling freely.
		 * 
		 * @param deltaTime The time (in seconds) since the last frame
		 */
		private function manageFreeScrolling( deltaTime : Number ) : void
		{
			// DEBUG INFO
			if (DEBUG)
			{
				trace('---- Start managing free scrolling');
			}
			
			var f:Number;
			var k:Number;
			var x0:Number;
			
			// Update the physics laws
			if (scrollingWithinContentArea)
			{
				f = FREE_SCROLLING_FRICTION_COEF; // friction coefficient
				k = 0; // spring rate (no spring on content)
				x0 = 0; // spring origin (no spring on content)
			}
			else
			{
				f = 3; // friction coefficient
				k = BOUNCING_SPRING_RATE; // spring rate
				x0 = bouncingAboveContent ? contentRect.left+10 : contentRect.right-_content.scrollRect.width-10; // spring origin
			}
			
			// Compute the new scrolling position after deltaTime.
			// The movement equation is one of a mobile moving on a plane surface with a friction coefficient, maybe attached to a spring (if in the bouncing area).
			// It is thus a second order differential equation: d2y/dt2 + f*dy/dt + k*(y-y0) = 0
			// Here we assume deltaTime is very short and thus discretize the equation and compute y based on y(t-1) and y(t-2).
			var x:Number = 1/(1/Math.pow(deltaTime,2)+f/deltaTime+k) * (_previousScrollPositions['t-1']*(f/deltaTime+2/Math.pow(deltaTime,2)) - _previousScrollPositions['t-2']/Math.pow(deltaTime,2) + k*x0);
			
			// When we go from the bouncing area to the content area, we force the position to be exactly on the top (or bottom) of the content area.
			// This prevents a vibration effect when the content is smaller than the screen (the elasticity would make the scroller go from one bouncing
			// area to the other).
			if (_previousScrollPositions['t-1'] < contentRect.left && x > contentRect.left )
				x = contentRect.left;
			if (_previousScrollPositions['t-1'] + _content.scrollRect.width > contentRect.right && x + _content.scrollRect.width < contentRect.right)
				x = contentRect.right - _content.scrollRect.width;
			
			// Apply the movement
			var deltaX:Number = x-_content.scrollRect.x;
			moveContentFromDelta(deltaX, deltaTime);
			
			// DEBUG INFO
			if (DEBUG)
			{
				trace('------ speed = ' + speed + ' | deltaX = ' + deltaX + ' | deltaTime = ' + deltaTime);
				trace('---- Stop managing free scrolling');
			}
		}
		
		/**
		 * DOC TODO
		 */
		private function manageForcedAnimatedScrolling( deltaTime : Number ) : void
		{
			// DEBUG INFO
			if (DEBUG)
			{
				trace('---- Start managing forced animated scrolling');
			}
			
			// Compute the total distance remaining and let moveContentFromDelta()'s speed control
			// do the job.
			var deltaX:Number = _forcedAnimatedScrollingTarget - scrollPosition;
			
			if (deltaX == 0)
			{
				_previousScrollPositions['t-1'] = _previousScrollPositions['t-2'] = scrollPosition;
				_forcedAnimatedScrolling = false;
			}
			else
				moveContentFromDelta(deltaX, deltaTime, _forcedAnimatedScrollingSpeed);
			
			// DEBUG INFO
			if (DEBUG)
			{
				trace('------ speed = ' + speed + ' | deltaX = ' + deltaX + ' | deltaTime = ' + deltaTime);
				trace('---- Stop managing forced animated scrolling');
			}
		}
		
		/**
		 * Scroll the content from a given distance.
		 * 
		 * @param deltaY The scrolling distance in pixels in the content coordinates.
		 * @param deltaTime The time interval corresponding to this movement (used to compute the current speed).
		 */
		private function moveContentFromDelta( deltaX : Number, deltaTime : Number, maxSpeed : Number = SCROLLING_MAX_SPEED ) : void
		{
			// Avoid unintended tiny movement on single tap
			// We except the case where it brings the scrolling to the top (or bottom) of the scrollable area
			// in order not to get stuck at the border of the bouncing area (and have the scroll bar not
			// disappearing.
			if (Math.abs(deltaX) < SCROLLING_MIN_AMPLITUDE && (scrollPosition + deltaX) != contentRect.left && (scrollPosition + deltaX) != (contentRect.right - _content.scrollRect.width))
				deltaX = 0;
			
			// Limit the instant speed
			if (Math.abs(deltaX/deltaTime) > maxSpeed)
				deltaX = deltaX/Math.abs(deltaX)*maxSpeed*deltaTime;
			
			// Show the scroll bar if the movement is initiated by finger
			if (deltaX && _touchingScreen)
				showScrollBar();
			
			// Update the scroll rect
			var scrollRect : Rectangle = _content.scrollRect.clone();
			scrollRect.x += deltaX;
			_content.scrollRect = scrollRect;
			
			// Compute the speed
			var currentSpeed:Number = 0.5*(deltaX/deltaTime+_speed);
			_speed = Math.abs(currentSpeed) >= SCROLLING_MIN_SPEED ? currentSpeed : 0;
			
			// Save the trajectory
			_previousScrollPositions['t-2'] = _previousScrollPositions['t-1'];
			_previousScrollPositions['t-1'] = scrollRect.x;
			
			// Update the scroll bar
			updateScrollBar();
			
			// Send an update event
			var event:Event = new Event(SCROLL_POSITION_CHANGE);
			dispatchEvent(event);
		}
		
		/**
		 * The current relative scrolling position. Value is:
		 * <ul>
		 * 	<li>negative if bouncing above the content area</li>
		 * 	<li>between 0 and 1 if scrolling within the content area</li>
		 * 	<li>greater than 1 if bouncing under the content area</li>
		 * </ul>
		 */
		private function get scrollingRelativePosition() : Number
		{
			// When the content is smaller than the viewport, we choose arbitrary values
			// to obtain the desired behavior.
			if (contentRect.width > _content.scrollRect.width)
				return (scrollPosition - contentRect.left) / (contentRect.width - _content.scrollRect.width);
			else if (scrollPosition == contentRect.left)
				return 0;
			else if (scrollPosition < contentRect.left)
				return -1;
			else
				return 2;
		}
		
		/** Indicate if the scrolling position is within the content area. */
		private function get scrollingWithinContentArea() : Boolean
		{
			return scrollingRelativePosition >= 0 && scrollingRelativePosition <= 1;
		}
		
		/** Indicate if the scrolling position is in the top bouncing area. */
		private function get bouncingAboveContent() : Boolean
		{
			return scrollingRelativePosition < 0;
		}
		
		/** Indicate if the scrolling position is in the bottom bouncing area. */
		private function get bouncingUnderContent() : Boolean
		{
			return scrollingRelativePosition > 1;
		}
		
		
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 								PRIVATE EVENT LISTENERS									 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		
		private function onMouseDown( event : MouseEvent ) : void
		{
			_container.mouseChildren = true  ;
			// The user starts touching the screen
			_touchingScreen = true;
			_timeOfLastMouseDown = getTimer();
			
			// Update finger position
			_previousFingerPosition = event.stageX;
			_currentFingerPosition = _previousFingerPosition;
			
			// Start listening to touch and frame events
			_container.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove );
//			_container.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut );
			_container.addEventListener(MouseEvent.MOUSE_UP, onMouseUp );
			_container.addEventListener(MouseEvent.RELEASE_OUTSIDE, onMouseUp );
			_container.addEventListener(Event.ENTER_FRAME, onEnterFrame );
			
			// DEBUG INFO
			if (DEBUG)
			{
				trace('>> onMouseDown - _currentFingerPosition = ' + _currentFingerPosition);
			}
		}
		
		private function onMouseUp( event : MouseEvent ) : void
		{
			_container.mouseChildren = true  ;
			// Stop listening to touch events
			_container.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//			_container.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			_container.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_container.removeEventListener(MouseEvent.RELEASE_OUTSIDE, onMouseUp );
			
			// If we get a mouse down and a mouse up between two frames, we need to either stop the scrolling,
			// either update the speed.
			if (_timeOfLastMouseDown > _timeOfLastFrame)
			{
				if (event.stageX == _currentFingerPosition)
				{
					_previousScrollPositions['t-1'] = scrollPosition;
					_previousScrollPositions['t-2'] = scrollPosition;
					_speed = 0;
				}
				else
				{
					onEnterFrame(null);
				}
			}
			
			// The user stops touching the screen
			_touchingScreen = false;
			
			// DEBUG INFO
			if (DEBUG)
			{
				trace('<< onMouseUp - _currentFingerPosition = ' + _currentFingerPosition);
			}
		}
		
		private function onMouseOut( event : MouseEvent ) : void
		{
			// If it was a mouse out outside of the container, we consider it as a mouse up
			if (!_container.getBounds(_container.stage).contains(event.stageX, event.stageY))
				onMouseUp(event);
		}
		
		private function onMouseMove( event : MouseEvent) : void
		{
			if(event.buttonDown) {
				_container.mouseChildren = false  ;
				// Indicate we received a touch and it hasn't been processed yet
				_pendingTouch = true;
				
				// Update finger position
				_currentFingerPosition = event.stageX;
				
				// DEBUG INFO
				if (DEBUG)
				{
					trace('xx onMouseMove - currentFingerPosition = ' + _currentFingerPosition);
				}
			}
		}
				
		private function onEnterFrame( event : Event ) : void
		{
			// DEBUG INFO
			if (DEBUG)
			{
				trace('-- onEnterFrame | speed = ' + speed);
			}
			
			// If content scroll rect not ready, can't do anything
			if (!_content.scrollRect)
				return;
			
			// Update time information (if deltaTime == 0, we wait for the next frame)
			var deltaTime:Number = getTimer() - _timeOfLastFrame;
			if (deltaTime == 0) return;
			_timeOfLastFrame += deltaTime;
			
			// If a forced animated scrolling was requested, we perform it.
			// Otherwise, if the user is touching the screen, or if we haven't processed the last touch yet, we follow the finger.
			// Otherwise, we let the physics take care of the scrolling.
			if (_forcedAnimatedScrolling)
				manageForcedAnimatedScrolling(deltaTime)
			else if (_touchingScreen || _pendingTouch)
				manageFingerScrolling(deltaTime)
			else
				manageFreeScrolling(deltaTime);
			
			// If we are in the scrolling area, not touching the screen, and with no speed,
			// we can stop refreshing the display and fade out the scroll bar.
			if (!_touchingScreen && scrollingWithinContentArea && speed == 0)
			{
				_container.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				hideScrollBar();
			}
			
			// DEBUG INFO
			if (DEBUG)
			{
				trace('-- onExitFrame');
			}
		}
				
		private function onScrollBarFadeOutTimerComplete( event : TimerEvent ) : void
		{
			if(_scrollBar)
				_scrollBar.addEventListener(Event.ENTER_FRAME, fadeOutScrollBar );
		};
	}
}