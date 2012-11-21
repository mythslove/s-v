package game.core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	
	import game.comm.GameSetting;
	import game.enums.AppStatus;
	
	public class GraphicsLayer extends BaseGraphicsLayer
	{
		public var canvas:Canvas ;
		public var layer1:Bitmap = new Bitmap();
		public var layer2:Bitmap = new Bitmap();
		public var layer3:Bitmap = new Bitmap();
		public var drawShap:Shape = new Shape();
		public var selectedLayer:Bitmap ;
		
		public function GraphicsLayer()
		{
			super();
			mouseChildren = false ;
			init();
		}
		private function init ():void
		{
			this.x = (GameSetting.SCREEN_WIDTH-640)>> 1 ;
			this.y = (GameSetting.SCREEN_HEIGHT-480)>> 1 ;
			canvas = new Canvas(640,480);
			addChild(canvas);
			layer1 = new Bitmap( new BitmapData(canvas.width,canvas.height,true,0xffffff));
			addChild(layer1);
			drawShap = new Shape();
			addChild(drawShap);
			layer2 = new Bitmap( new BitmapData(canvas.width,canvas.height,true,0xffffff));
			addChild(layer2);
			layer3 = new Bitmap( new BitmapData(canvas.width,canvas.height,true,0xffffff));
			addChild(layer3);
			selectedLayer = layer1 ;
		}
		
		override protected function onTouchHandler(e:TouchEvent):void
		{
			if(GameSetting.status==AppStatus.ZOOM){
				super.onTouchHandler(e);
			}else if(GameSetting.status==AppStatus.DRAW){
				switch(e.type)
				{
					case TouchEvent.TOUCH_BEGIN:
						initDraw();
						addEventListener(Event.ENTER_FRAME , updateDrawHandler );
						break;
					case TouchEvent.TOUCH_MOVE :
						drawShap.graphics.lineTo(mouseX , mouseY);
						break ;
					default:
						//重置
						selectedLayer.bitmapData.draw( drawShap) ;
						drawShap.graphics.clear() ;
						removeEventListener(Event.ENTER_FRAME , updateDrawHandler );
						break ;
				}
			}
		}
		
		private function initDraw():void
		{
			drawShap.graphics.lineStyle(25,GameSetting.color,1);
			drawShap.graphics.moveTo(mouseX , mouseY);
		}
		
		private function updateDrawHandler(e:Event):void
		{
			
		}
	}
}