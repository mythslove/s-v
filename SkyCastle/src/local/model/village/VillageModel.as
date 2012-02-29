package local.model.village
{
	import bing.utils.Guid;
	
	import local.comm.GlobalDispatcher;
	import local.events.UserInfoEvent;
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
		
		/**
		 * 获取玩家的信息 
		 */		
		public function getMeInfo():void
		{
			me = new PlayerVO();
			me.cash = 100;
			me.coin = 10 ;
			me.exp = 1;
			me.maxExp = 10 ;
			me.level = 1;
			me.wood=20;
			me.stone=29;
			me.id = Guid.create();
			me.name = "binghe";
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