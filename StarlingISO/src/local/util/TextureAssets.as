package local.util
{
	import flash.display.BitmapData;
	
	import starling.textures.TextureAtlas;

	public class TextureAssets
	{
		private static var _instance:TextureAssets ;
		public static function get instance():TextureAssets{
			if(!_instance) _instance = new TextureAssets();
			return _instance ;
		}
		//=======================================
		
		public var buildingTexture:TextureAtlas ;
		public var buildingBmd:BitmapData ;
		
		public function createBuildingTexture():void
		{
			
		}
	}
}