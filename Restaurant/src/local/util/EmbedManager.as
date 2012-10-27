package local.util
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class EmbedManager
	{
		public static var ui_png:Bitmap ;
		public static var ui_xml:XML ;
		public static var map_png:Bitmap;
		public static var map_xml:XML ;
		public static var verdana_fnt:XML ;
		
		[Embed(source="../assets/map/BG_TILE.jpg")]
		public static const BG_TILE:Class ;
		
		
		private static var _textureDic:Dictionary = new Dictionary() ;
		
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
			var xml:XML = XML( new EmbedManager[name+"_XML"]() )  ;
			var atals:TextureAtlas = new TextureAtlas( Texture.fromBitmap( bmp,false ) , xml );
			_textureDic[name] = atals ;
			bmp.bitmapData.dispose();
			return atals;
		}
		
		
		
		public static function getMapTexture(name:String ):Texture
		{
			if( _textureDic[name] ) return _textureDic[name] as Texture ;
			
			var mapTextureAtlas:TextureAtlas ;
			if( !_textureDic["map_png"] ){
				mapTextureAtlas = new TextureAtlas( Texture.fromBitmap( map_png,false ) , map_xml );
				_textureDic["map_png"] = mapTextureAtlas ;
				map_png.bitmapData.dispose();
				map_png = null ;
				map_xml =  null ;
				ResourceUtil.instance.deleteRes( "game_map_png");
				ResourceUtil.instance.deleteRes( "game_map_xml");
			}else{
				mapTextureAtlas = _textureDic["map_png"]  ;
			}
			
			var texture:Texture =  mapTextureAtlas.getTexture(name);
			_textureDic[name] = texture ;
			return texture ;
		}
		public static function getMapImage( name:String ):Image{
			return new Image(getMapTexture(name));
		}
		
		
		
		
		
		
		public static function getUITexture( name:String ):Texture
		{
			if( _textureDic[name] ) return _textureDic[name] as Texture ;
			
			var uiTextureAtlas:TextureAtlas ;
			if( !_textureDic["ui_png"] ){
				uiTextureAtlas = new TextureAtlas( Texture.fromBitmap( ui_png , false ) , ui_xml );
				_textureDic["ui_png"] = uiTextureAtlas ;
				ui_png.bitmapData.dispose();
				ui_png = null ;
				ui_xml = null ;
				ResourceUtil.instance.deleteRes( "game_ui_png");
				ResourceUtil.instance.deleteRes( "game_ui_xml");
			}else{
				uiTextureAtlas = _textureDic["ui_png"]  ;
			}
			
			var texture:Texture =  uiTextureAtlas.getTexture(name);
			_textureDic[name] = texture ;
			return texture ;
		}
		public static function getUIImage( name:String ):Image{
			return new Image(getUITexture(name));
		}
	}
}