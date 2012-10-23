package bing.starling.component
{
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class TileImage extends Image
	{
		public function TileImage(texture:Texture)
		{
			super(texture);
			texture.repeat = true ;
		}
		
		public function setSize( w:Number , h:Number):void
		{
			var horizontally :int= Math.ceil(w/texture.width) ;
			var vertically:int = Math.ceil(h/texture.height) ;
			setTexCoords(1,new Point(horizontally,0));
			setTexCoords(2,new Point(0,vertically));
			setTexCoords(3,new Point(horizontally,vertically));
			width = w ;
			height = h ;
		}
	}
}