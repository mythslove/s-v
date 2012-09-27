package local.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class EmbedManager
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
		private static var _bmdDic:Dictionary = new Dictionary();
		private static var _frameDic:Dictionary = new Dictionary();
		
		public static function createTextureByName( name:String ):Texture
		{
			if( _textureDic[name] ) return _textureDic[name] as Texture ;
			
			var bmp:Bitmap = new EmbedManager[name]() as Bitmap ;
			var texture:Texture = Texture.fromBitmap( bmp , false );
			_textureDic[name] = texture ;
			bmp.bitmapData.dispose();
			return texture;
		}
		
		public static function createTextureAtlas( name:String ):TextureAtlas
		{
			if( _textureDic[name] ) return _textureDic[name] as TextureAtlas ;
			
			var bmp:Bitmap = new EmbedManager[name]() as Bitmap ;
			_bmdDic[name] = bmp.bitmapData; 
			var xml:XML = XML( new AtlasXml() )  ;
			parseXML( xml ) ;
			var atals:TextureAtlas = new TextureAtlas( Texture.fromBitmap( bmp,false ) , xml );
			_textureDic[name] = atals ;
//			bmp.bitmapData.dispose();
			return atals;
		}
		
		public static function getBmd( name:String ):BitmapData
		{
			return _bmdDic[name] as BitmapData;
		}
		
		public static function getBmpPoint( name:String ):Point
		{
			return _frameDic[name] as Point;
		}
			
		private static function parseXML( xml:XML ):void
		{
			var children:* = xml.children();
			var len:int = children.length();
			var item:* ;
			for( var i:int = 0 ; i<len ; ++i ){
				item = children[i] ;
				_frameDic[ String(item.@name) ] = new Point( int(item.@x) , int(item.@y) );
			}
		}
	}
}