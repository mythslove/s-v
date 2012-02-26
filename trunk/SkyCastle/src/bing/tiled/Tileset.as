package bing.tiled
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class Tileset
	{
		public var imgUrl:String ;
		public var bmds:Vector.<BitmapData> ;
		
		public var firstgrid:int ;
		public var name:String;
		public var tilewidth:int ;
		public var tileheight:int ;
		public var spacing:int ;
		public var margin:int ;
		public var tiles:Vector.<Tile> ;
		
		
		public function dispose():void 
		{
			if(bmds)
			{
				for each( var bmd:BitmapData in bmds)
				{
					bmd.dispose();
				}
				bmds = null ;
			}
			if(tiles)
			{
				for each( var tile:Tile in tiles)
				{
					tile.dispose() ;
				}
				tiles = null ;
			}
		}
	}
}