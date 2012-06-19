package app.core
{
	import app.comm.Data;
	import app.comm.EditorStatus;
	
	import flash.display.BlendMode;
	import flash.display.Shape;
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
		
		public var blend:String = BlendMode.NORMAL ;
		
		
		public function GameScene( picName:String )
		{
			super(picName);
			Data.gameScene = this ;
		}
		
		override protected function addedToStage():void
		{
			super.addedToStage() ;
			Data.editorStatus = EditorStatus.BUCHKET ;
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
					if(Data.editorStatus==EditorStatus.BRUSH || Data.editorStatus==EditorStatus.ERASER ){
						stage.addEventListener(Event.ENTER_FRAME , update );
					}
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
					_picTempBmd.fillRect( _picTempBmd.rect , 0xff );
					_ltPoint.x = 0 ;
					_ltPoint.y = 0 ;
					_maskColor = 0xFF ;
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
			if(_tick>=1)
			{
				_picTempBmd.draw(_canvas,null,null,null,_maskCurrRect) ;
				_picTempBmd.threshold( _lineMaskBmd,_maskCurrRect , _ltPoint ,"!=",_maskColor,0xFF );
				if(blend==BlendMode.NORMAL){
					_picBmp.bitmapData.copyPixels( _picTempBmd , _maskCurrRect , _ltPoint , null ,null , true );
				}else{
					var shape:Shape = new Shape();
					shape.graphics.beginBitmapFill( _picTempBmd, null ,false);
					shape.graphics.drawRect(_ltPoint.x,_ltPoint.y,_maskCurrRect.width ,_maskCurrRect.height);
					shape.graphics.endFill();
					_picBmp.bitmapData.draw(shape,null,null,blend,_maskCurrRect) ;
				}
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
			_ltPoint.x = _maskCurrRect.x ;
			_ltPoint.y = _maskCurrRect.y ;
			
			//直接填充图，用的时候要把update事件取消
			if(Data.editorStatus==EditorStatus.BUCHKET){
				_picBmp.bitmapData.threshold( _lineMaskBmd , _maskCurrRect, _ltPoint , "==" , _maskColor , _selectedPen.color );
			}else if( Data.editorStatus==EditorStatus.CLEAR){
				_picBmp.bitmapData.threshold( _lineMaskBmd , _maskCurrRect, _ltPoint , "==" , _maskColor , 0xFF );
			}
			_canvas.graphics.lineStyle(30,_selectedPen.color,1);
			_canvas.graphics.moveTo(stage.mouseX , stage.mouseY);
		}
	}
}