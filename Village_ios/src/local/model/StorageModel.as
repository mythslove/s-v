package local.model
{
	public class StorageModel
	{
		private static var _instance:StorageModel;
		public static function get instance():StorageModel
		{
			if(!_instance) _instance = new StorageModel();
			return _instance; 
		}
		//=================================
	}
}