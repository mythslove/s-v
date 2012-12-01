package game.core.car
{
	import nape.space.Space;
	
	import starling.display.Sprite;
	
	public class BaseCar extends Sprite
	{
		private var _space:Space ;
		private var _px:Number ;
		private var _py:Number ;
		
		public function BaseCar( space:Space , px:Number, py:Number )
		{
			super();
			this._space = space ;
			this._px = px ;
			this._py = py ;
		}
		
		protected function createBody():void
		{
			
		}
	}
}