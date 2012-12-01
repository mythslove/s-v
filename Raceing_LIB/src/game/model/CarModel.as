package game.model
{
	public class CarModel
	{
		private static var _instance:CarModel;
		public static function get instance():CarModel{
			if(!_instance) _instance = new CarModel();
			return _instance ;
		}
		//===============================
		public function CarModel()
		{
		}
	}
}