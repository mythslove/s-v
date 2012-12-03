package game.core.car
{
	import bing.res.ResPool;
	
	import flash.display.Bitmap;
	
	import game.vos.CarVO;
	
	import nape.dynamics.InteractionGroup;
	import nape.phys.Body;
	import nape.phys.Compound;
	import nape.space.Space;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.extensions.PDParticleSystem;
	import starling.extensions.ParticleSystem;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class BaseCar extends Sprite
	{
		protected var _space:Space ;
		protected var _px:Number ;
		protected var _py:Number ;
		protected var _carGroup:InteractionGroup;
		protected var _carVO:CarVO ;
		
		private var _texture:Texture ;
		protected var _textureAltas:TextureAtlas;
		
		public var carBody:Body ;
		public var leftWheel:Body;
		public var rightWheel:Body;
		public var compound:Compound; 
		
		public var leftWheelParticle:PDParticleSystem ;
		public var rightWheelParticle:PDParticleSystem ;
		public var gasParticle:PDParticleSystem ;
		
		public function BaseCar( group:InteractionGroup , carVO:CarVO ,  space:Space , px:Number, py:Number )
		{
			super();
			this._space = space ;
			this._px = px ;
			this._py = py ;
			this._carGroup = group ;
			this._carVO = carVO ;
			createBody();
		}
		
		protected function createBody():void
		{
			compound = new Compound();
			compound.group = _carGroup ;
			
			var textureBmp:Bitmap = ResPool.instance.getResVOByResId("car"+_carVO.id).resObject as Bitmap;
			var textureXML:XML = XML(ResPool.instance.getResVOByResId("carXML"+_carVO.id).resObject) ;
			
			_texture = Texture.fromBitmap( textureBmp , false  );
			_textureAltas = new TextureAtlas(_texture,textureXML);
		}
		
		public function createParticles( dustTexture:Texture ):void
		{
			var dustPex:XML = XML(ResPool.instance.getResVOByResId("DustParticle_PEX").resObject);
			leftWheelParticle = new PDParticleSystem(dustPex,dustTexture);
			rightWheelParticle = new PDParticleSystem(dustPex,dustTexture);
			Starling.juggler.add( leftWheelParticle );
			Starling.juggler.add( rightWheelParticle );
		}
		
		override public function dispose():void
		{
			super.dispose();
			_texture.dispose();
			_texture = null ;
			_textureAltas.dispose();
			_textureAltas = null ;
			_carVO = null ;
			_carGroup = null ;
			_space = null ;
			compound = null ;
			Starling.juggler.remove( leftWheelParticle );
			Starling.juggler.remove( rightWheelParticle );
			leftWheelParticle.dispose();
			leftWheelParticle = null ;
			rightWheelParticle.dispose() ;
			rightWheelParticle = null ;
		}
	}
}