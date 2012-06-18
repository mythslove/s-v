package app.core
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class GameScene extends BaseGameScene
	{
		private var _ltPoint:Point = new Point();
		private var _isMove:Boolean;
		private var _tick:int ;
		private var _maskRectHash:Dictionary = new Dictionary();
		private var _maskCurrRect:Rectangle ;
		private var _mat:Matrix ;
		private var _maskColor:uint = 0xFF ;
		
		public function GameScene( picName:String )
		{
			super(picName);
		}
		
		override protected function addedToStage():void
		{
			super.addedToStage() ;
			_container.addEventListener( MouseEvent.MOUSE_DOWN , onMouseHandler );
		}
		
		private function onMouseHandler( e:MouseEvent):void
		{
			e.stopPropagation() ;
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					initDraw();
					stage.addEventListener(MouseEvent.MOUSE_MOVE , onMouseHandler);
					stage.addEventListener(MouseEvent.MOUSE_UP, onMouseHandler);
					stage.addEventListener(Event.ENTER_FRAME , update );
					break ;
				case MouseEvent.MOUSE_MOVE:
					if(e.buttonDown && _maskColor !=0xFF )
					{
						_canvas.graphics.lineTo(stage.mouseX , stage.mouseY);
						_isMove = true ;
					}
					break ;
				default:
					//重置
					_picTempBmd = _picBmp.bitmapData.clone();
					_ltPoint.x = 0 ;
					_ltPoint.y = 0 ;
					_canvas.graphics.clear() ;
					_isMove = false ;
					stage.removeEventListener(MouseEvent.MOUSE_MOVE , onMouseHandler);
					stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseHandler);
					stage.removeEventListener(Event.ENTER_FRAME , update );
					break ;
			}
		}
		
		private function update(e:Event):void
		{
			++_tick;
			if(_tick>=2)
			{
				_picTempBmd.draw(_canvas) ;
				_ltPoint.x = _maskCurrRect.x ;
				_ltPoint.y = _maskCurrRect.y ;
				_picTempBmd.threshold( _lineMaskBmd,_maskCurrRect , _ltPoint ,"!=",_maskColor , 0xFF );
				_picBmp.bitmapData.copyPixels( _picTempBmd,_maskCurrRect,_ltPoint,null,null,true);
				_tick = 0;
			}
		}
		
		private function initDraw():void
		{
			_maskColor = _lineMaskBmd.getPixel32(stage.mouseX,stage.mouseY);
			if(_maskRectHash.hasOwnProperty(_maskColor)){
				_maskCurrRect = _maskRectHash[_maskColor];
			}else{
				_maskCurrRect = _lineMaskBmd.getColorBoundsRect(_maskColor,_maskColor);
				_maskRectHash[_maskColor] = _maskCurrRect ;
			}
			
			//直接填充图，用的时候要把update事件取消
			//_pic.bitmapData.threshold( _maskBmd , _maskCurrRect, new Point(_maskCurrRect.x,_maskCurrRect.y) , "==" , _maskColor , _penColor );
			
			_canvas.graphics.lineStyle(20,_selectedPen.color,1,true);
			_canvas.graphics.moveTo(stage.mouseX , stage.mouseY);
		}
	}
}