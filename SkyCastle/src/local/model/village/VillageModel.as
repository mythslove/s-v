package local.model.village
{
	import local.model.village.vos.PlayerVO;

	public class VillageModel
	{
		private static var _instance:VillageModel;
		public static function get instance():VillageModel
		{
			if(!_instance) _instance = new VillageModel();
			return _instance; 
		}
		//=================================
		
		public var me:PlayerVO ;
		
		public var friend:PlayerVO ; //到好友的村庄
		
		public var isHome:Boolean = true ;
		
		/**
		 * 访问好友的村庄 
		 * @param id 好友的id
		 */		
		public function inviteFriendVillage( id:String ):void
		{
			
		}
	}
}