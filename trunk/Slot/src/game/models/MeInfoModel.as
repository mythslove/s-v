package game.models
{
	import flash.events.EventDispatcher;
	
	import game.models.vos.UserVO;
	
	public class MeInfoModel extends EventDispatcher
	{
		private static var _instance:MeInfoModel;
		public static function get  instance():MeInfoModel
		{
			if(!_instance) _instance = new MeInfoModel();
			return _instance ;
		}
		//----------------------------------------------------------------
		public var me:UserVO ;
	}
}