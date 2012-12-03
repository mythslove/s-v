package game.core.car
{
	import game.vos.CarVO;
	
	import nape.dynamics.InteractionGroup;
	import nape.space.Space;
	
	public class Car1 extends BaseCar
	{
		public function Car1(group:InteractionGroup ,carVO:CarVO , space:Space , px:Number, py:Number)
		{
			super(group ,carVO , space , px, py);
		}
		
		override protected function createBody():void
		{
			super.createBody();
			
		}
	}
}