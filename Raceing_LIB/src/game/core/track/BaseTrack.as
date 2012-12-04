package game.core.track
{
	import bing.res.ResPool;
	
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	
	import game.comm.GameSetting;
	import game.vos.TrackVO;
	
	import nape.callbacks.CbType;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Compound;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class BaseTrack extends Sprite
	{
		private var _texture:Texture ;
		protected var _textureAltas:TextureAtlas;
		public function get textureAltas():TextureAtlas{
			return _textureAltas;
		}
		
		protected var _space:Space ;
		protected var _trackVO:TrackVO ;
		
		public var len:int ; //路的长度
		public var roadCompound:Compound = new Compound();
		public var roadType:CbType = new CbType();
		
		public function BaseTrack( trackVO:TrackVO , space:Space )
		{
			super();
			this._space = space ;
			this._trackVO = trackVO ;
			createBody();
		}
		
		protected function createBody():void
		{
			var textureXML:XML = XML(ResPool.instance.getResVOByResId("roadXML").resObject) ;
			
			var roadObject:Object = ResPool.instance.getResVOByResId("road").resObject ;
			if(roadObject is ByteArray){
				_texture = Texture.fromAtfData( roadObject as ByteArray , 1  , false  );
			}else if(roadObject is Bitmap){
				_texture = Texture.fromBitmap( roadObject as Bitmap , false );
			}
			_textureAltas = new TextureAtlas(_texture,textureXML);
		}
		
		protected function createWall():void
		{
			var wall:Body = new Body(BodyType.STATIC) ;
			wall.shapes.add( new Polygon(Polygon.rect(0,0,50,GameSetting.SCREEN_HEIGHT)));
			wall.shapes.add( new Polygon(Polygon.rect(len-50,0,50,GameSetting.SCREEN_HEIGHT)));
			wall.space = _space ;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_trackVO = null ;
			_textureAltas.dispose();
			_textureAltas = null ;
			_texture.dispose();
			_texture = null ;
			_space = null ;
			roadCompound = null ;
			roadType = null ;
		}
	}
}