package local
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;

	public class Assets
	{
		[Embed(source="../assets/starling_round.png")]
		private static const starling_round:Class ;
		
		
		private static var _textureDic:Dictionary = new Dictionary() ;
		
		public static function createTextureByName( name:String ):Texture
		{
			if( _textureDic[name] ) return _textureDic[name] as Texture ;
			
			var bmp:Bitmap = new Assets[name]() as Bitmap ;
			var texture:Texture = Texture.fromBitmap( bmp );
			_textureDic[name] = texture ;
			return texture;
		}
	}
}