package local.model
{
	import bing.amf3.ResultEvent;
	import bing.utils.Guid;
	import bing.utils.SystemUtil;
	
	import flash.system.System;
	
	import local.comm.GameData;
	import local.comm.GameRemote;
	import local.comm.GlobalDispatcher;
	import local.events.UserInfoEvent;
	import local.game.GameWorld;
	import local.model.vos.PlayerVO;
	import local.utils.PopUpManager;
	import local.views.CenterViewContainer;
	import local.views.loading.MapChangeLoading;

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
		
		private var _ro:GameRemote ;
		public function PlayerModel()
		{
			_ro = new GameRemote("PlayerService");
			_ro.addEventListener(ResultEvent.RESULT ,  onResultHandler );
		}
		
		private function onResultHandler( e:ResultEvent ):void
		{
			SystemUtil.debug("返回数据：",e.service+"."+e.method , e.result );
			switch( e.method )
			{
				case "getPlayer":
					var player:PlayerVO = e.result as PlayerVO ;
					if(player.uid==GameData.me_uid) {
						GameData.isHome = true ;
						me = player ;
						// pickups
						PickupModel.instance.myPickups = player.pickups ;
						//collections
						CollectionModel.instance.myCollection = player.collections ;
						//	显示和更新玩家显示信息
						CenterViewContainer.instance.topBar.updateTopBar();
						GlobalDispatcher.instance.dispatchEvent( new UserInfoEvent(UserInfoEvent.USER_INFO_UPDATED));
					} else {
						GameData.isHome = false ;
						friend = player ;
					}
					PopUpManager.instance.removeCurrentPopup();
					GameWorld.instance.initWorld();
					break;
				case "levelup":
					if(e.result)
					{
						GameWorld.instance.effectScene.clear();
						me = e.result as PlayerVO;
						// pickups
						PickupModel.instance.myPickups = player.pickups ;
						//collections
						CollectionModel.instance.myCollection = player.collections ;
						//	显示和更新玩家显示信息
						CenterViewContainer.instance.topBar.updateTopBar();
						GlobalDispatcher.instance.dispatchEvent( new UserInfoEvent(UserInfoEvent.USER_INFO_UPDATED));
					}
					break ;
			}
		}
		
		/**
		 * 发送玩家升级到服务器 
		 *@param currentlevel 当前的等级
		 * */		
		public function sendLevelUp( currentLevel:int ):void
		{
			_ro.getOperation("levelup").send( currentLevel);
		}
		
		/**
		 * 获取玩家的信息 
		 * @param uid 玩家uid
		 * @param mapId 地图id
		 */		
		public function getPlayer( uid:String , mapId:String ):void
		{
			_ro.getOperation("getPlayer").send( uid , mapId );
			//添加loading
			PopUpManager.instance.clearAll();
			var loading:MapChangeLoading = new MapChangeLoading();
			PopUpManager.instance.addQueuePopUp( loading );
			
//			//下面为模拟玩家数据，要测试接口的话，注释掉下面的
//			GameData.isHome = true ;
//			me = new PlayerVO();
//			me.cash = 100;
//			me.coin = 1000 ;
//			me.maxExp = 100 ;
//			me.exp = 14 ;
//			me.level = 1;
//			me.wood=200;
//			me.stone=209;
//			me.maxEnergy = 100 ;
//			me.energy = 86 ;
//			me.uid = Guid.create();
//			me.name = "bingheliefeng";
//			CenterViewContainer.instance.topBar.updateTopBar();
//			GlobalDispatcher.instance.dispatchEvent( new UserInfoEvent(UserInfoEvent.USER_INFO_UPDATED));
//			GameWorld.instance.initWorld();
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
		public function checkCashEnough( spendCash:int ):Boolean{
			return me.cash>=spendCash ;
		}
		
		/**
		 * 判断木材是否足够 
		 * @param spendWood
		 * @return 
		 */		
		public function checkWood( spendWood:int ):Boolean{
			return me.wood>=spendWood ;
		}
		
		/**
		 * 判断石头是否足够 
		 * @param spendStone
		 * @return 
		 */		
		public function checkStone( spendStone:int ):Boolean{
			return me.stone>=spendStone ;
		}
	}
}