package game.core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.events.TouchEvent;
	
	import game.comm.GameSetting;
	import game.enums.AppStatus;
	import game.util.GameUtil;
	
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
			this.x = (100+GameSetting.SCREEN_WIDTH-GameSetting.canvasW)>> 1 ;
			this.y = (GameSetting.SCREEN_HEIGHT-GameSetting.canvasH)>> 1 ;
			canvas = new Canvas(GameSetting.canvasW,GameSetting.canvasH);
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
			e.stopPropagation();
			if(GameSetting.status==AppStatus.ZOOM)
			{
				super.onTouchHandler(e);
			}
			else
			{
				switch(e.type)
				{
					case TouchEvent.TOUCH_BEGIN:
						var color:uint = GameSetting.status==AppStatus.ERASER ? canvas.color : GameSetting.color ;
						drawShap.graphics.lineStyle(GameSetting.penSize*2 , color , GameSetting.penAlpha );
						drawShap.graphics.moveTo(mouseX , mouseY);
						break;
					case TouchEvent.TOUCH_MOVE :
						drawShap.graphics.lineTo(mouseX , mouseY);
						break ;
					default:
						if(GameSetting.blur>0){
							drawShap.filters = GameUtil.blurFilter ;
						}
						//重置
						var mode:String = GameSetting.status==AppStatus.ERASER ? BlendMode.ERASE : null  ;
						selectedLayer.bitmapData.draw( drawShap,null,null,mode) ;
						drawShap.graphics.clear() ;
						drawShap.filters = null ;
						break ;
				}
			}
		}
		
	}
}