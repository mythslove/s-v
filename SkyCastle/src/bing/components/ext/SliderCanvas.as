package local.views.base
{
	import bing.components.interfaces.IUIAnimation;
	import bing.components.utils.UIAniManager;
	import bing.utils.ContainerUtil;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import local.views.BaseView;
	
	[Event(name="move",type="flash.events.Event")]
	public class SliderCanvas extends BaseView implements IUIAnimation
	{
		public static const MOVE:String = "move";
		public static const SLIDER_TYPE_H:String = "sliderTypeH";
		public static const SLIDER_TYPE_V:String = "sliderType V";
		public static const SLIDER_TYPE_BOTH:String = "sliderTypeBoth";
		public static const SLIDER_TYPE_NONE:String = "sliderTypeNone";
		//===========================================
		public var slideSpeed:Number=0.5;
		public var row:int = 5, col:Number=5 ;
		public var rowGap:int = 5, colGap:Number=15 ;
		private var _sliderType:String ;
		private var _renders:Array ;
		private var _mouseIsMove:Boolean ;
		private var _isDrag:Boolean;
		private var _wid:Number,_het:Number ;
		private var _endX:int,_endY:int ;
		private var _container:Sprite;
		private var _mask:Shape;
		private var _tempRow:int , _tempCol:int ;
		private var _numPerPage:int ; //每页最多显示几个
		private var _containerPoint:Point = new Point();
		private var _dragTime:int ;
		private var _lockDrag:Boolean = false ;
		
		public function SliderCanvas( )
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

		public function init(wid:Number=100 , het:Number=100 , slideType:String= SLIDER_TYPE_NONE):void
		{
			this._wid = wid;
			this._het = het ;
			this._sliderType = slideType ;
			_mask = new Shape();
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRect(0,0,wid,het);
			_mask.graphics.endFill();
			addChild(_mask);
			_container = new Sprite();
			_container.mouseEnabled = false ;
			addChild(_container);
			_container.mask=_mask ;
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(-1,-1,_wid+2,_het+2);
			this.graphics.endFill();
		}
		
		override protected function addedToStage():void{
			UIAniManager.instance.addAniView( this );
			configListeners();
		}
		
		private function configListeners():void {
			addEventListener(MouseEvent.MOUSE_UP , onMouseEvtHandler );
			addEventListener(MouseEvent.MOUSE_OUT , onMouseEvtHandler );
			addEventListener(MouseEvent.MOUSE_MOVE , onMouseEvtHandler );
		}
		
		private function onMouseEvtHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			switch(e.type)
			{
				case MouseEvent.MOUSE_OUT:
					if(e.target!=this||e.currentTarget!=this){
						break ;
					}
				case MouseEvent.MOUSE_UP:
					_container.stopDrag();
					_isDrag = false ;
					if(_mouseIsMove){
						ModifyEnd(e);
					}
					_mouseIsMove = false;
					mouseChildren=true ;
					break ;
				case MouseEvent.MOUSE_MOVE:
					if(e.buttonDown && !_mouseIsMove ){
						_mouseIsMove=true;
						mouseChildren=false ;
						if(!_isDrag){
							startDragContainer();
						}
						this.dispatchEvent( new Event(MOVE));
					}
					break ;
			}
		}
		
		private function startDragContainer():void
		{
			if(_lockDrag) return ;
			
			_containerPoint.x = _container.x ;
			_containerPoint.y = _container.y ;
			if(_sliderType!=SLIDER_TYPE_NONE)
			{
				var rect:Rectangle = new Rectangle();
//						rect.x = -_container.width*scaleX+_wid ;
//						rect.y = -_container.height*scaleY+_het ;
				if(_sliderType==SLIDER_TYPE_H){
					rect.x = -_container.width*scaleX ;
					rect.width =_container.width*scaleX+_wid ;
					rect.height = 0 ;
				}else if(_sliderType==SLIDER_TYPE_V){
					rect.y = -_container.height*scaleY ;
					rect.height = _container.height*scaleY+_het ;
					rect.width =0 ;
				}else if(_sliderType==SLIDER_TYPE_BOTH){
					rect.x = -_container.width*scaleX ;
					rect.width =_container.width*scaleX+_wid ;
					rect.y = -_container.height*scaleY ;
					rect.height = _container.height*scaleY+_het ;
				}
				_container.startDrag( false  , rect );
				_isDrag = true;
				_dragTime = getTimer();
			}
		}
		
		/** 确定最后的位置 */
		protected function ModifyEnd(e:MouseEvent):void
		{
			if(renders==null || renders.length==0){
				_endX=0;
				_endY=0;
				return ;
			}
			_endX = _containerPoint.x ;
			_endY = _containerPoint.y ;
			var testDis:int = (getTimer()-_dragTime)>400?_wid*0.5:50 ;
			var offsetX:Number = _container.x-_containerPoint.x ;
			var offsetY:Number = _container.y-_containerPoint.y ;
			var distance:int = 2 ;
			var renderWH:int ;
			if(_sliderType==SLIDER_TYPE_H)
			{
				renderWH= renders[0].width+colGap ;
				distance = _numPerPage*renderWH ;
				if(offsetX>testDis)  {//向右
					_endX =  Math.floor( _endX/renderWH ) *renderWH ;
					_endX+=distance;
				}else if(offsetX<-testDis) {
					_endX = Math.ceil( _endX/renderWH )*renderWH ;
					_endX-=distance;
				}
			}
			else if(_sliderType==SLIDER_TYPE_V)
			{
				renderWH= renders[0].height+rowGap ;
				distance = _numPerPage*renderWH ;
				if(offsetY>testDis)  {//向下
					_endY = Math.floor( _endY/renderWH )*renderWH ;
					_endY+=distance;
				}else if(offsetY<-testDis) {
					_endY = Math.ceil( _endY/renderWH )*renderWH ;
					_endY-=distance;
				}
			}else {
				renderWH= renders[0].width+colGap ;
				_endX = Math.floor( _endX/renderWH )*renderWH ;
				distance = _numPerPage*renderWH ;
				if(offsetX>testDis)  {//向右
					_endX+=distance;
				}else if(offsetX<-testDis) {
					_endX-=distance;
				}
				renderWH= renders[0].height+rowGap ;
				distance = _numPerPage*renderWH ;
				if(offsetY>testDis)  {//向下
					_endY = Math.floor( _endY/renderWH )*renderWH ;
					_endY+=distance;
				}else if(offsetY<-testDis) {
					_endY = Math.ceil( _endY/renderWH )*renderWH ;
					_endY-=distance;
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
			//优化显示renders
			optimizeDisplayRender();
		}
		
		/*优化显示区域*/
		private function optimizeDisplayRender():void
		{
			for each( var render:Sprite in _renders)
			{
				if(render.x+_endX>=-_wid && render.x+_endX<=_wid*2 
					&&render.y+_endY>=-_het && render.y+_endY<=_het*2 )
				{
					render.visible=true;
				}
				else
				{
					render.visible=false ;
				}
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
			//优化显示renders
			optimizeDisplayRender();
		}
		public function get renders():Array{
			return _renders ;
		}
		
		protected function showRenderByH():void
		{
			var render:MovieClip ;
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
			_numPerPage = (_wid/(render.width+colGap))>>0;
		}
		
		protected function showRenderByV():void
		{
			var render:MovieClip ;
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
			_numPerPage = (_het/(render.height+rowGap))>>0;
		}
		
		public function update():void
		{
			if(!_mouseIsMove && _container){
				_container.x+= ( (_endX-_container.x)*slideSpeed)>>0 ;
				_container.y+= ( (_endY-_container.y)*slideSpeed)>>0 ;
			}
		}
		
		private function removeListeners():void{
			removeEventListener(MouseEvent.MOUSE_UP , onMouseEvtHandler );
			removeEventListener(MouseEvent.MOUSE_OUT , onMouseEvtHandler );
			removeEventListener(MouseEvent.MOUSE_MOVE , onMouseEvtHandler );
		}
		
		override protected function removedFromStage():void{
			UIAniManager.instance.removeAniView(this);
			ContainerUtil.removeChildren(_container);
			_container = null ;
			_mask = null;
			_containerPoint = null ;
			removeListeners();
		}
	}
}