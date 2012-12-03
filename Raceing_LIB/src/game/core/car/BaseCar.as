package game.core.car
{
	import nape.dynamics.InteractionGroup;
	import nape.phys.Body;
	import nape.phys.Compound;
	import nape.space.Space;
	
	import starling.display.Sprite;
	
	public class BaseCar extends Sprite
	{
		private var _space:Space ;
		private var _px:Number ;
		private var _py:Number ;
		public var _carGroup:InteractionGroup;
		
		public var carBody:Body ;
		public var leftWheel:Body;
		public var rightWheel:Body;
		public var compound:Compound; 
		
		public function BaseCar( group:InteractionGroup , space:Space , px:Number, py:Number )
		{
			super();
			this._space = space ;
			this._px = px ;
			this._py = py ;
			this._carGroup = group ;
		}
		
		protected function createBody():void
		{
			compound = new Compound();
			compound.group = _carGroup ;
		}
	}
}