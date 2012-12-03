package game.util
{
	import game.core.car.BaseCar;
	import game.core.car.Car1;
	import game.vos.CarVO;
	
	import nape.dynamics.InteractionGroup;
	import nape.space.Space;

	public class CarFactory
	{
		public static function createCar(group:InteractionGroup ,carVO:CarVO , space:Space , px:Number, py:Number):BaseCar
		{
			var car:BaseCar ;
			switch( carVO.id )
			{
				case 1:
					car  = new Car1(group ,carVO , space , px, py);
					break ;
			}
			return car;
		}
	}
}