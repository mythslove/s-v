package  {
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	
	public class BitmapTextField extends Sprite {
		
		
		public var txt:TextField ;
		private var _bmp:Bitmap = new Bitmap();
		
		public function BitmapTextField() {
			super();
			mouseChildren=mouseEnabled = false;
			removeChild(txt);
			addChild(_bmp);
		}
		
		
		public function set text( value:String ):void
		{
			scaleX = scaleY = 1;
			txt.width = width ;
			txt.height = height ;
			txt.text = value ;
			_bmp.bitmapData = new BitmapData(txt.width,txt.height);
			draw();
		}
		
		private function draw():void
		{
			_bmp.bitmapData.fillRect(_bmp.bitmapData.rect , 0xffffff );
			_bmp.bitmapData.draw( txt );
		}
		
		override public function set filters( value:Array):void
		{
			txt.filters = value ;
		}
	}
	
}
