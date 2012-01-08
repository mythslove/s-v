package bing.tiled
{
	import flash.utils.Dictionary;

	public class Tile
	{
		public var id:int ;
		public var prop:Dictionary ;
		
		public function dispose():void 
		{
			prop=null ;
		}
	}
}