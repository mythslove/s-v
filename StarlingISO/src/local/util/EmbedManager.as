package local.util
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class EmbedManager
	{
		//=========地图资源，地图数据和图片======================
		[ Embed(source="../assets/map/mapData.map", mimeType="application/octet-stream") ]
		public static const MapData:Class ; //地图数据
		
		[ Embed(source="../assets/map/map.png")]
		public static const MAP:Class ;
		[ Embed(source="../assets/map/map.xml", mimeType="application/octet-stream")]
		public static const MAP_XML:Class ;
		//=======================================
		
		
		[Embed(source="../assets/ui_iphone/ui.xml", mimeType="application/octet-stream")]
		public static const UI_IPHONE_XML:Class;
		[Embed(source="../assets/ui_iphone/ui.png")]
		public static const UI_IPHONE:Class;
		
		
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
			var texture:Texture = createTextureAtlas("MAP").getTexture(name) ;
			_textureDic[name] = texture ;
			return texture ;
		}
		public static function getMapImage( name:String ):Image{
			var img:Image = new Image(getMapTexture(name));
//			img.scaleX = img.scaleY = 2; 
			return img;
		}
		
		
		
		
		
		
		public static function getUITexture( name:String ):Texture{
			
			if( _textureDic[name] ) return _textureDic[name] as Texture ;
			
			var uiName:String = "UI_IPHONE";
//			if(GameSetting.isIpad){
//				uiName = "UI_IPAD";
//			}
			var texture:Texture = createTextureAtlas(uiName).getTexture(name) ;
			_textureDic[name] = texture ;
			return texture ;
		}
		public static function getUIImage( name:String ):Image{
			var img:Image = new Image(getUITexture(name));
//			img.scaleX = img.scaleY = 2; 
			return img;
		}
	}
}