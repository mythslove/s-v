package game.core.car
{
	import bing.res.ResPool;
	
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	
	import game.vos.CarVO;
	
	import nape.constraint.Constraint;
	import nape.dynamics.InteractionGroup;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Compound;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.space.Space;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
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
		
		public var dustParticle:PDParticleSystem ;
		public var gasParticle:PDParticleSystem ;
		public var maxVelocity:Number ;
		public var maxImpulse:Number ;
		
		public function BaseCar( group:InteractionGroup , carVO:CarVO ,  space:Space , px:Number, py:Number )
		{
			super();
			this._space = space ;
			this._px = px ;
			this._py = py ;
			this._carGroup = group ;
			this._carVO = carVO ;
			this.maxVelocity = carVO.carParams["velocity"].value ;
			this.maxImpulse = carVO.carParams["impulse"].value;
			createBody();
			createParticles();
		}
		
		protected function createBody():void
		{
			compound = new Compound();
			compound.group = _carGroup ;
			
			var textureXML:XML = XML(ResPool.instance.getResVOByResId("carXML"+_carVO.id).resObject) ;
			var carObject:Object = ResPool.instance.getResVOByResId("car"+_carVO.id).resObject ;
			if(carObject is ByteArray){
				_texture = Texture.fromAtfData( carObject as ByteArray , 1  , false  );
			}else if(carObject is Bitmap){
				_texture = Texture.fromBitmap( carObject as Bitmap , false );
			} 
			_textureAltas = new TextureAtlas(_texture,textureXML);
		}
		
		protected function createParticles():void
		{
			var dustPex:XML = XML(ResPool.instance.getResVOByResId("DustParticle_PEX").resObject);
			var dustTexture :Texture = _textureAltas.getTexture("dustTexture");
			dustParticle = new PDParticleSystem(dustPex,dustTexture);
			Starling.juggler.add( dustParticle );
			addChildAt(dustParticle,0);
			dustParticle.start();
		}
		
		protected function graphicUpdate(body:Body):void
		{
			if(body.graphic && body.graphic is DisplayObject)
			{
				var gp:Vec2 = body.localToWorld(body.graphicOffset);
				var gra:DisplayObject = body.graphic as DisplayObject;
				gra.x = gp.x;
				gra.y = gp.y;
				gra.rotation = body.rotation ;
				if(dustParticle && body==leftWheel){
					dustParticle.emitterX  = gp.x-body.bounds.width ;
					dustParticle.emitterY = gp.y ;
				}
			}
		}
		
		protected function circle(x:Number,y:Number,r:Number , material:Material ):Body {
			var b:Body = new Body();
			b.shapes.add(new Circle(r,null,material));
			b.position.setxy(x,y);
			return b;
		}
		
		public function breakCar():void
		{
			var len:int   = compound.constraints.length ;
			for( var i:int = 0; i<len ; ++i){
				var constraint:Constraint = compound.constraints.at(i);
				constraint.breakUnderForce = true ;
				constraint.active= false;
			}
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
			Starling.juggler.remove( dustParticle );
			dustParticle.dispose();
			dustParticle = null ;
		}
	}
}