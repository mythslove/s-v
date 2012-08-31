package local.model
{
	import local.map.item.MoveItem;

	public class BuildingModel
	{
		private static var _instance:BuildingModel;
		public static function get instance():BuildingModel
		{
			if(!_instance) _instance = new BuildingModel();
			return _instance; 
		}
		//=================================
		
		
	}
}