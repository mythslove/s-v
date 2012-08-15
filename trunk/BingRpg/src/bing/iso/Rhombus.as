package bing.iso
{
	import flash.display.Shape;
	/**
	 * 菱形 
	 * @author zhouzhanglin
	 */	
	public class Rhombus extends Shape
	{
		public var color:uint = 0x00ff00 ;
		
		public function Rhombus( size:int )
		{
			draw(color , size );
		}
		
		public function draw(color:uint , size:int ):void 
		{
			this.graphics.clear() ;
			this.color = color ;
			this.graphics.lineStyle(2,color);
			this.graphics.beginFill(color,0.5);
			this.graphics.moveTo( 0 , 0 );
			this.graphics.lineTo( size , size/2 );
			this.graphics.lineTo( 0 , size );
			this.graphics.lineTo( -size , size/2 );
			this.graphics.endFill() ;
		}
	}
}