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
		
		public function Rhombus( size:int , color:uint = 0x00ff00 )
		{
			this.color = color ;
			draw(color , size );
			cacheAsBitmap = true ;
		}
		
		public function draw(color:uint , size:int ):void 
		{
			this.graphics.clear() ;
			this.color = color ;
//			this.graphics.lineStyle(1,color);
			this.graphics.beginFill(color,1);
			this.graphics.moveTo( 0 , 0 );
			this.graphics.lineTo( size , size/2 );
			this.graphics.lineTo( 0 , size );
			this.graphics.lineTo( -size , size/2 );
			this.graphics.lineTo( 0 , 0);
			this.graphics.endFill() ;
			
			
			
//			this.graphics.lineStyle(1,0xffffff);
			this.graphics.moveTo( 0 , 2 );
			this.graphics.lineTo( size-2 , size/2 );
			this.graphics.lineTo( 0 , size-2 );
			this.graphics.lineTo( -size+2 , size/2 );
			this.graphics.lineTo( 0 ,2 );
		}
	}
}