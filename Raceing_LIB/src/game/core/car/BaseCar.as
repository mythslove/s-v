package game.core.car
{
	import bing.res.ResPool;
	
	import flash.display.Bitmap;
	
	import game.vos.CarVO;
	
	import nape.dynamics.InteractionGroup;
	import nape.phys.Body;
	import nape.phys.Compound;
	import nape.space.Space;
	
	import starling.display.Sprite;
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
		}
	}
}