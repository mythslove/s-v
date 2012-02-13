package game.models
{
	public class FriendsModel
	{
		private static var _instance:FriendsModel;
		public static function get  instance():FriendsModel
		{
			if(!_instance) _instance = new FriendsModel();
			return _instance ;
		}
		//----------------------------------------------------------------
	}
}