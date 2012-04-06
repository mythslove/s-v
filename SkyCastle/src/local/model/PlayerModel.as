package local.model
{
	import bing.utils.Guid;
	
	import local.comm.GlobalDispatcher;
	import local.events.UserInfoEvent;
	import local.model.vos.PlayerVO;
	/**
	 * 玩家信息Model 
	 * @author zzhanglin
	 */	
	public class PlayerModel
	{
		private static var _instance:PlayerModel;
		public static function get instance():PlayerModel
		{
			if(!_instance) _instance = new PlayerModel();
			return _instance; 
		}
		//=================================
		
		public var me:PlayerVO ; //当前玩家的信息
		
		public var friend:PlayerVO ; //去好友玩家的信息
		
		/**
		 * 发送玩家升级到服务器 
		 *@param currentlevel 当前的等级
		 * */		
		public function sendLevelUp( currentLevel:int ):void
		{
			
		}
		
		/**
		 * 访问好友的村庄 
		 * @param uid 好友的uid
		 */		
		public function inviteFriendVillage( uid:String ):void
		{
			
		}
		
		/**
		 * 获取玩家的信息 
		 * @param uid 玩家uid
		 * @param mapId 地图id
		 */		
		public function getMeInfo( uid:String , mapId:String ):void
		{
			me = new PlayerVO();
			me.cash = 100;
			me.coin = 1000 ;
			me.minExp = 2 ;
			me.maxExp = 100 ;
			me.exp = 14 ;
			me.level = 1;
			me.wood=200;
			me.stone=209;
			me.maxEnergy = 100 ;
			me.energy = 86 ;
			me.uid = Guid.create();
			me.name = "bingheliefeng";
			GlobalDispatcher.instance.dispatchEvent( new UserInfoEvent(UserInfoEvent.USER_INFO_UPDATED));
		}
		
		/**
		 * 判断金币是否足够 
		 * @param spendCoin
		 * @return 
		 */		
		public function checkCoinEnough( spendCoin:int ):Boolean
		{
			return me.coin>=spendCoin ;
		}
		
		/**
		 * 判断钱是否足够 
		 * @param spendCash
		 * @return 
		 */		
		public function checkCashEnough( spendCash:int ):Boolean
		{
			return me.cash>=spendCash ;
		}
		
		/**
		 * 判断木材是否足够 
		 * @param spendWood
		 * @return 
		 */		
		public function checkWood( spendWood:int ):Boolean
		{
			return me.wood>=spendWood ;
		}
		
		/**
		 * 判断石头是否足够 
		 * @param spendStone
		 * @return 
		 */		
		public function checkStone( spendStone:int ):Boolean
		{
			return me.stone>=spendStone ;
		}
	}
}