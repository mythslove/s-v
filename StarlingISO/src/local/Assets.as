package local
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets
	{
		[Embed(source="../assets/bgFill1.jpg")]
		private static const bgFill1:Class ;
		[Embed(source="../assets/bgTree.png")]
		private static const bgTree:Class ;
		
		
		[Embed(source="../assets/atlas.xml", mimeType="application/octet-stream")]
		public static const AtlasXml:Class;
		
		[Embed(source="../assets/atlas.png")]
		public static const Atlas:Class;
		
		
		private static var _textureDic:Dictionary = new Dictionary() ;
		
		public static function createTextureByName( name:String ):Texture
		{
			if( _textureDic[name] ) return _textureDic[name] as Texture ;
			
			var bmp:Bitmap = new Assets[name]() as Bitmap ;
			var texture:Texture = Texture.fromBitmap( bmp , false );
			_textureDic[name] = texture ;
			bmp.bitmapData.dispose();
			return texture;
		}
		
		public static function createTextureAtlas( name:String ):TextureAtlas
		{
			if( _textureDic[name] ) return _textureDic[name] as TextureAtlas ;
			
			var bmp:Bitmap = new Assets[name]() as Bitmap ;
			var atals:TextureAtlas = new TextureAtlas( Texture.fromBitmap( bmp,false ) , XML( new AtlasXml() ) );
			_textureDic[name] = atals ;
			bmp.bitmapData.dispose();
			return atals;
		}
	}
}