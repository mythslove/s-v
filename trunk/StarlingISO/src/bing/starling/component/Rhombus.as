package bing.starling.component
{
	import starling.display.Quad;
	import starling.utils.VertexData;
	
	/**
	 * 画菱形 
	 * @author zhouzhanglin
	 */	
	public class Rhombus extends Quad
	{
		public function Rhombus(width:Number, height:Number, color:uint=16777215)
		{
			super(width, height, color, true );
			mVertexData = new VertexData(4, true);
			mVertexData.setPosition(0, 0.0, 0.0);
			mVertexData.setPosition(1, width>>1 , height>>1 );
			mVertexData.setPosition(2, -width>>1 , height>>1 ); 
			mVertexData.setPosition(3, 0.0  , height );
			mVertexData.setUniformColor(color);
		}
	}
}