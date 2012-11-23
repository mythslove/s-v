package game.core
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import game.comm.GameSetting;
	
	public class BaseGraphicsLayer extends Sprite
	{
		/**===============用于地图移动和缩放=========================*/
		protected var _isMove:Boolean ; //当前是否在移动地图
		protected var _isGesture:Boolean ; //当前是否在缩放地图
		
		protected var _touches:Vector.<Touch> = Vector.<Touch>([ new Touch(0,0,0) , new Touch(0,0,0) ]) ; //两个手指的触摸对象
		protected var _touchCount:int ; //手指触摸数量
		protected var _touchFinger1:Point = new Point(); //第一个点击的手指
		protected var _middle:Point = new Point(); //缩放时的中间点位置
		protected var _moveSpeed:Number = 0.5  ; //移动的速度
		/**====================================================*/
		
		public function BaseGraphicsLayer()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		protected function addedHandler( e:Event ):void
		{
			if(Multitouch.supportsTouchEvents){
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT ;
				this.addEventListener(TouchEvent.TOUCH_BEGIN , onTouchHandler ) ;
				stage.addEventListener(TouchEvent.TOUCH_MOVE , onTouchHandler ) ;
				stage.addEventListener(TouchEvent.TOUCH_END , onTouchHandler ) ;
			}else{
				stage.addEventListener(MouseEvent.MOUSE_WHEEL , onMouseWheelHandler);
			}
		}
		
		/*多点缩放地图*/
		protected function onTouchHandler( e:TouchEvent ):void
		{
			switch(e.type)
			{
				case TouchEvent.TOUCH_BEGIN:
					++_touchCount ;
					if(_touchCount==1){
						_touchFinger1.x = e.stageX/root.scaleX ;
						_touchFinger1.y = e.stageY/root.scaleX ;
						_touches[0].stageX = e.stageX/root.scaleX ;
						_touches[0].stageY = e.stageY/root.scaleX ;
						_touches[0].prevX = e.stageX/root.scaleX ;
						_touches[0].prevY = e.stageY/root.scaleX ;
						_touches[0].id = e.touchPointID ;
					}
					else if(_touchCount==2){
						_middle.x = _touchFinger1.x+(e.stageX/root.scaleX-_touchFinger1.x)*0.5 ;
						_middle.y = _touchFinger1.y+(e.stageY/root.scaleX-_touchFinger1.y)*0.5 ;
						_touches[1].stageX = e.stageX/root.scaleX ;
						_touches[1].stageY = e.stageY/root.scaleX ;
						_touches[1].prevX = e.stageX/root.scaleX ;
						_touches[1].prevY = e.stageY/root.scaleX ;
						_touches[1].id = e.touchPointID ;
					}
					break;
				case TouchEvent.TOUCH_MOVE :
					if(_touchCount>=2){
						_isGesture = true ;
						var touch:Touch;
						for(var i:int=0;i<2;++i){
							touch = _touches[i] as Touch ;
							if(touch.id==e.touchPointID){
								touch.prevX = touch.stageX ;
								touch.prevY = touch.stageY;
								touch.stageX = e.stageX/root.scaleX ;
								touch.stageY = e.stageY/root.scaleX ;
								//放大缩小
								var touchA:Touch = _touches[0];
								var touchB:Touch = _touches[1];
								
								var currentPosA:Point  = new Point( touchA.stageX , touchA.stageY  );
								var previousPosA:Point = new Point( touchA.prevX , touchA.prevY );
								var currentPosB:Point  = new Point( touchB.stageX,touchB.stageY );
								var previousPosB:Point = new Point( touchB.prevX , touchB.prevY );
								
								var currentVector:Point  = currentPosA.subtract(currentPosB);
								var previousVector:Point = previousPosA.subtract(previousPosB);
								
								// scale
								var sizeDiff:Number = currentVector.length / previousVector.length;
								if(!GameSetting.isPad) 
									sizeDiff = sizeDiff>1 ? 1+(sizeDiff-1)*1.3 : 1-(1-sizeDiff)*1.3 ;
								changeWorldScale( sizeDiff , _middle.x , _middle.y );
							}
						}
					}
					break ;
				case TouchEvent.TOUCH_END:
					--_touchCount ;
					if(_touchCount<0) _touchCount = 0 ;
					break ;
			}
		}
		
		//===============修改地图的缩放值和地图的位置======================
		private var _zoomM:Matrix = new Matrix();
		private var _zoomObj:Object = {"value":1};
		private var _zoomTween:TweenLite ;
		protected function changeWorldScale( value:Number , px:Number , py:Number , time:Number=0.2):void
		{
			if(scaleX*value>1 && scaleX*value<2.2 ) 
			{
				var prevScale:Number = scaleX ;
				var prevX:Number =x , prevY:Number = y ;
				
				_zoomObj.value=1;
				if(_zoomTween){
					_zoomTween.kill() ;
					_zoomTween = null ;
				}
				_zoomTween = TweenLite.to( _zoomObj , time , { value:value , onUpdate:function():void{
					_zoomM.identity() ;
					_zoomM.scale(prevScale,prevScale);
					_zoomM.translate( prevX , prevY );
					_zoomM.tx -= px;
					_zoomM.ty -= py;
					_zoomM.scale(_zoomObj.value,_zoomObj.value);
					_zoomM.tx += px;
					_zoomM.ty += py;
					
					scaleX = _zoomM.a ;
					scaleY = _zoomM.d ;
					x = (100+GameSetting.SCREEN_WIDTH-GameSetting.canvasW*scaleX)>> 1 ;
					y = (GameSetting.SCREEN_HEIGHT-GameSetting.canvasH*scaleY)>> 1 ;
				}} );
				
			}
			this.x = (100+GameSetting.SCREEN_WIDTH-GameSetting.canvasW*scaleX)>> 1 ;
			this.y = (GameSetting.SCREEN_HEIGHT-GameSetting.canvasH*scaleY)>> 1 ;
		}
		
		/*用于鼠标缩放地图*/
		private function onMouseWheelHandler(e:MouseEvent):void
		{
			e.stopPropagation();
			var value:Number = e.delta>0?1.12:0.92 ;
			changeWorldScale(value,root.mouseX,root.mouseY);
		}
	}
}


class Touch
{
	public var id:int ;
	public var stageX:Number ;
	public var stageY:Number ;
	
	public var prevX:Number ;
	public var prevY:Number ;
	
	public function Touch( id:int , stageX:Number , stageY:Number )
	{
		this.id = id ;
		this.stageX = stageX ;
		this.stageY = stageY ;
	}
}