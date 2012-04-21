package local.model
{
	

	/**
	 * 收藏箱的Model 
	 * @author zzhanglin
	 */	
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