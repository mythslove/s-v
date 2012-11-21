package game.core
{
	import flash.display.Shape;
	
	import game.comm.GameSetting;
	
	public class Pen extends Shape
	{
		public function Pen()
		{
			super();
			draw();
			cacheAsBitmap = true ;
		}
		
		public function draw():void
		{
			graphics.clear();
			graphics.lineStyle( 3,0);
			graphics.drawCircle(0,0,GameSetting.penSize);
			graphics.endFill();
		}
	}
}