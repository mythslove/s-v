package bing.tiled
{
	import flash.utils.Dictionary;

	public class Map
	{
		public var orientation:String ;//orthogonal
		public var row:int ;
		public var col:int ;
		public var tilewidth:int ;
		public var tileheight:int ;
		public var layerCount:int ;
		
		public var tilesets:Vector.<Tileset> = new Vector.<Tileset>() ;
		public var layers:Vector.<Layer> = new Vector.<Layer>();
		
		public var tilesDic:Dictionary ;
	}
}