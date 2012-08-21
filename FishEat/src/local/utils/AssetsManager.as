package local.utils
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class AssetsManager
	{
		
		
		[Embed(source="../assets/bgTexture.xml", mimeType="application/octet-stream")]
		private static const bgTextureXML:Class;
		[Embed(source="../assets/bgTexture.png")]
		private static const bgTexture:Class;
		
		[Embed(source="../assets/fishTexture.xml", mimeType="application/octet-stream")]
		private static const fishTextureXML:Class;
		[Embed(source="../assets/fishTexture.png")]
		private static const fishTexture:Class;
		
		
		
		private static var _textureDic:Dictionary = new Dictionary() ;
		
		public static function createTextureByName( name:String ):Texture
		{
			if( _textureDic[name] ) return _textureDic[name] as Texture ;
			
			var bmp:Bitmap = new AssetsManager[name]() as Bitmap ;
			var texture:Texture = Texture.fromBitmap( bmp , false );
			_textureDic[name] = texture ;
			bmp.bitmapData.dispose();
			return texture;
		}
		
		public static function createTextureAtlas( name:String ):TextureAtlas
		{
			if( _textureDic[name] ) return _textureDic[name] as TextureAtlas ;
			
			var bmp:Bitmap = new AssetsManager[name]() as Bitmap ;
			var atals:TextureAtlas = new TextureAtlas( Texture.fromBitmap( bmp,false ) , XML( new  AssetsManager[name+"XML"]()  ) );
			_textureDic[name] = atals ;
			bmp.bitmapData.dispose();
			return atals;
		}
	}
}