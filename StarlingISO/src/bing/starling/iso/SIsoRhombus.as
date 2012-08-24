package bing.starling.iso
{
	import starling.display.Quad;
	import starling.utils.VertexData;
	
	/**
	 * 画菱形 
	 * @author zhouzhanglin
	 */	
	public class SIsoRhombus extends Quad
	{
		public function SIsoRhombus(width:Number, height:Number, color:uint=16777215,premultipliedAlpha:Boolean=true)
		{
			super(width, height, color, premultipliedAlpha );
			mVertexData = new VertexData(4, premultipliedAlpha);
			mVertexData.setPosition(0, 0.0, 0.0);
			mVertexData.setPosition(1, width>>1 , height>>1 );
			mVertexData.setPosition(2, -width>>1 , height>>1 ); 
			mVertexData.setPosition(3, 0.0  , height );
			mVertexData.setUniformColor(color);
		}
	}
}