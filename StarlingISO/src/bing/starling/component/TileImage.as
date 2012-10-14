package bing.starling.component
{
	import flash.geom.Point;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class TileImage extends Image
	{
		public function TileImage(texture:Texture)
		{
			super(texture);
			texture.repeat = true ;
			blendMode = BlendMode.NONE ;
		}
		
		public function setSize( w:Number , h:Number):void
		{
			var factor:Number = w/h ;
			var tile:int = w/texture.width ;
			
			
			
			var horizontally:int = tile ;
			var vertically:int = tile/factor ;
			setTexCoords(1,new Point(horizontally,0));
			setTexCoords(2,new Point(0,vertically));
			setTexCoords(3,new Point(horizontally,vertically));
			width = w ;
			height = h ;
		}
	}
}