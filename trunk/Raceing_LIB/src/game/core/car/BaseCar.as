package game.core.car
{
	import game.vos.CarVO;
	
	import nape.dynamics.InteractionGroup;
	import nape.phys.Body;
	import nape.phys.Compound;
	import nape.space.Space;
	
	import starling.display.Sprite;
	
	public class BaseCar extends Sprite
	{
		protected var _space:Space ;
		protected var _px:Number ;
		protected var _py:Number ;
		protected var _carGroup:InteractionGroup;
		protected var _carVO:CarVO ;
		
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
		}
	}
}