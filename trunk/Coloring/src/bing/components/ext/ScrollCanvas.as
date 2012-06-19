package bing.components.ext
{
	import bing.components.BingComponent;
	import bing.components.interfaces.IUIAnimation;
	import bing.components.utils.UIAniManager;
	import bing.utils.ContainerUtil;
	import bing.utils.MathUtil;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * 自由滚动的容器 
	 * @author zhouzhanglin
	 */	
	public class ScrollCanvas  extends BingComponent implements IUIAnimation
	{
		public static const MOVE:String = "move";
		public static const SLIDER_TYPE_H:String = "sliderTypeH";
		public static const SLIDER_TYPE_V:String = "sliderType V";
		public static const SLIDER_TYPE_BOTH:String = "sliderTypeBoth";
		public static const SLIDER_TYPE_NONE:String = "sliderTypeNone";
		//===========================================
		public var maxSpeed:int = 40 ;
		public var slideSpeed:Number=0.4;
		public var row:int = 5, col:Number=5 ;
		public var rowGap:int = 5, colGap:Number=15 ;
		private var _sliderType:String ;
		private var _renders:Array ;
		private var _wid:Number,_het:Number ;
		private var _endX:int,_endY:int ;
		private var _container:Sprite;
		private var _mask:Shape;
		private var _tempRow:int , _tempCol:int ;
		private var _mouseDownPos:Point = new Point();
		private var _containerPos:Point = new Point();
		private var _lockDrag:Boolean = false ;
		private var _offsetX:int , _offsetY:int ;
		private var _dragTime:Number ;
		private var _mouseIsDown:Boolean ;
		
		public function ScrollCanvas( )
		{
			super();
		}
		
		public function get lockDrag():Boolean
		{
			return _lockDrag;
		}
		
		public function set lockDrag(value:Boolean):void
		{
			_lockDrag = value;
		}
		
		public function get offsetX():Number
		{
			return _container.x ;
		}
		
		public function get offsetY():Number
		{
			return _container.y ;
		}
		
		public function init(wid:Number=100 , het:Number=100 , slideType:String= SLIDER_TYPE_NONE , haveMask:Boolean=true ):void
		{
			this._wid = wid;
			this._het = het ;
			this._sliderType = slideType ;
			if(haveMask){
				_mask = new Shape();
				_mask.graphics.beginFill(0);
				_mask.graphics.drawRect(0,0,wid,het);
				_mask.graphics.endFill();
				addChild(_mask);
			}
			_container = new Sprite();
			_container.mouseEnabled = false ;
			addChild(_container);
			if(haveMask) _container.mask=_mask ;
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(-1,-1,_wid+2,_het+2);
			this.graphics.endFill();
		}
		
		override protected function addedToStage():void{
			UIAniManager.instance.addAniView( this );
			configListeners();
		}
		
		private function configListeners():void {
			addEventListener(MouseEvent.MOUSE_MOVE , onMouseEvtHandler );
			addEventListener(MouseEvent.MOUSE_DOWN , onMouseEvtHandler );
			addEventListener(MouseEvent.MOUSE_UP , onMouseEvtHandler );
			addEventListener(MouseEvent.MOUSE_OUT , onMouseEvtHandler );
			addEventListener(MouseEvent.ROLL_OUT , onMouseEvtHandler );
		}
		
		private function onMouseEvtHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			if(_lockDrag) return ;
			
			switch(e.type)
			{
				case MouseEvent.MOUSE_OUT:
					if(e.target!=this||e.currentTarget!=this){
						break ;
					}
				case MouseEvent.ROLL_OUT:
				case MouseEvent.MOUSE_UP:
					if(_mouseIsDown){
						var timeCha:Number = getTimer()-_dragTime;
						var temp:Number = 1/(timeCha*0.002) ;
						if(_sliderType==SLIDER_TYPE_H)
						{
							if(timeCha<500 && MathUtil.distance(_containerPos.x,0,_container.x,0)>10 )  	_endX+= temp*_offsetX ;
							else _endX = _container.x ;
						}
						else if(_sliderType==SLIDER_TYPE_V)
						{
							if(timeCha<500  && MathUtil.distance(_containerPos.y,0,_container.y,0)>10 )  	_endY+= temp*_offsetY;
							else _endY = _container.y ;
						}
						else if(timeCha<500  && MathUtil.distance(_containerPos.x,_containerPos.y,_container.x,_container.y)>10 ) 
						{
							_endX+= temp*_offsetX;
							_endY+= temp*_offsetY;
						}else{
							_endX = _container.x ;
							_endY = _container.y ;
						}
					}
					
					if(_endX>0 || _container.width<_wid) _endX=0 ;
					else if(_endX<-_container.width*scaleX+_wid){
						_endX = -_container.width*scaleX+_wid ;
					}
					if(_endY>0 || _container.height<_het) _endY=0 ;
					else if(_endY<-_container.height*scaleY+_het){
						_endY = -_container.height*scaleY+_het ;
					}
					mouseChildren=true ;
					_mouseIsDown = false ;
					break ;
				case MouseEvent.MOUSE_DOWN:
					_mouseIsDown = true ;
					_mouseDownPos.x = mouseX ;
					_mouseDownPos.y = mouseY ;
					_containerPos.x = _container.x ;
					_containerPos.y = _container.y ;
					_endX = _container.x ;
					_endY = _container.y ;
					_dragTime = getTimer();
					break ;
				case MouseEvent.MOUSE_MOVE:
					if(e.buttonDown){
						if(!_mouseIsDown){
							_mouseIsDown = true ;
							_mouseDownPos.x = mouseX ;
							_mouseDownPos.y = mouseY ;
							_containerPos.x = _container.x ;
							_containerPos.y = _container.y ;
							_endX = _container.x ;
							_endY = _container.y ;
							_dragTime = getTimer();
						}
						mouseChildren=false;
						_offsetX = mouseX-_mouseDownPos.x ;
						_offsetY = mouseY-_mouseDownPos.y ;
						_endX = _containerPos.x + _offsetX ;
						_endY = _containerPos.y + _offsetY ;
						ModifyEnd();
					}
					break ;
			}
		}
		
		
		/** 确定最后的位置 */
		protected function ModifyEnd():void
		{
			if(renders==null || renders.length==0){
				_endX=0;
				_endY=0;
				return ;
			}
			if(_sliderType==SLIDER_TYPE_H){
				_endY=0;
			}else if(_sliderType==SLIDER_TYPE_V){
				_endX=0;
			}
		}
		
		public function set renders(value:Array ):void{
			_renders = value;
			ContainerUtil.removeChildren(_container);
			_container.y = _container.x=0;
			if(_renders&&_renders.length>0){
				switch(_sliderType){
					case SLIDER_TYPE_H :
						showRenderByH();
						break ;
					default:
						showRenderByV() ;
						break;
				}
			}
			_endX = _container.x= 0 ;
			_endY = _container.y= 0 ;
		}
		public function get renders():Array{
			return _renders ;
		}
		
		protected function showRenderByH():void
		{
			var render:Sprite ;
			var len:int  = _renders.length ;
			_tempRow  = 0 ; //当前行
			_tempCol = 0 ;//当前列
			for( var i:int  = 0 ; i<len ; ++i){
				render = _renders[i] ;
				render.x = _tempCol*(render.width + colGap);
				render.y = _tempRow*(render.height+rowGap);
				_container.addChild(render);
				_tempRow++;
				if(_tempRow==row){
					_tempRow = 0;
					_tempCol++;
				}
			}
		}
		
		protected function showRenderByV():void
		{
			var render:Sprite ;
			var len:int  = _renders.length ;
			_tempRow  = 0 ; //当前行
			_tempCol = 0 ;//当前列
			for( var i:int  = 0 ; i<len ; ++i){
				render = _renders[i] ;
				render.x = _tempCol*(render.width + colGap);
				render.y = _tempRow*(render.height+rowGap);
				_container.addChild(render);
				_tempCol++;
				if(_tempCol==col){
					_tempCol = 0;
					_tempRow++;
				}
			}
		}
		
		public function update():void
		{
			if(_container){
				if(_sliderType!=SLIDER_TYPE_V)
				{
					var speedX:int = (_endX-_container.x)*slideSpeed ;
					if(!_mouseIsDown && _endX<0 && _endX+_container.width>_wid ) speedX*=0.1 ;
					if( speedX>maxSpeed ) speedX=maxSpeed  ;
					else if(speedX <-maxSpeed) speedX= -maxSpeed  ;
					_container.x+=  speedX ;
				}
				else if(_sliderType!=SLIDER_TYPE_H)
				{
					var speedY:int = (_endY-_container.y)*slideSpeed ;
					if(!_mouseIsDown && _endY<0 && _endY+_container.height>_het ) speedY*=0.1 ;
					if(speedY>maxSpeed ) speedY=maxSpeed  ;
					else if(speedY <-maxSpeed) speedY= -maxSpeed  ;
					_container.y+=  speedY ;
				}
				
			}
		}
		
		private function removeListeners():void{
			removeEventListener(MouseEvent.MOUSE_MOVE , onMouseEvtHandler );
			removeEventListener(MouseEvent.MOUSE_DOWN , onMouseEvtHandler );
			removeEventListener(MouseEvent.MOUSE_UP , onMouseEvtHandler );
			removeEventListener(MouseEvent.MOUSE_OUT , onMouseEvtHandler );
			removeEventListener(MouseEvent.ROLL_OUT , onMouseEvtHandler );
		}
		
		override protected function removedFromStage():void{
			UIAniManager.instance.removeAniView(this);
			ContainerUtil.removeChildren(_container);
			_container = null ;
			_mask = null;
			_mouseDownPos= null;
			 _containerPos= null;
			removeListeners();
		}
	}
}