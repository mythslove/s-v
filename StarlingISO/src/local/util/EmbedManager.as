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
		[ Embed(source="../assets/map/bottomsea1.png") ]
		public static const Bottomsea1:Class ;
		[ Embed(source="../assets/map/bottomsea2.png") ]
		public static const Bottomsea2:Class ;
		[ Embed(source="../assets/map/rightsea1.png") ]
		public static const Rightsea1:Class ;
		[ Embed(source="../assets/map/rightsea2.png") ]
		public static const Rightsea2:Class ;
		[ Embed(source="../assets/map/heightmap1.png") ]
		public static const HeightMap1:Class ;
		[ Embed(source="../assets/map/heightmap2.png") ]
		public static const HeightMap2:Class ;
		[ Embed(source="../assets/map/rightheight1.png") ]
		public static const RightHeight1:Class ;
		[ Embed(source="../assets/map/smallheightmap1.png") ]
		public static const SmallHeightMap:Class ;
		[ Embed(source="../assets/map/water1.png") ]
		public static const Water1:Class ;
		[ Embed(source="../assets/map/mapBlock.png") ]
		public static const MapBlock:Class ;
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
		
		
		
		
		
		
		
		public static function getUITextureAtlas():TextureAtlas{
			var name:String = "UI_IPHONE";
//			if(GameSetting.isIpad){
//				name = "UI_IPAD";
//			}
			
			if( _textureDic[name] ) return _textureDic[name] as TextureAtlas ;
			
			var bmp:Bitmap = new EmbedManager[name]() as Bitmap ;
			var xml:XML = XML( new EmbedManager[name+"_XML"]() )  ;
			var atals:TextureAtlas = new TextureAtlas( Texture.fromBitmap( bmp,false ) , xml );
			_textureDic[name] = atals ;
			bmp.bitmapData.dispose();
			return atals;
		}
		
		public static function getUITexture( name:String ):Texture{
			
			if( _textureDic[name] ) return _textureDic[name] as Texture ;
			
			var texture:Texture = getUITextureAtlas().getTexture(name) ;
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