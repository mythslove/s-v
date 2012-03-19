package  local.views
{
	import local.comm.GlobalDispatcher;
	import local.events.UserInfoEvent;
	import local.model.VillageModel;
	import local.model.vos.PlayerVO;
	import local.views.topbar.TopBarCoin;
	import local.views.topbar.TopBarEnergy;
	import local.views.topbar.TopBarExp;
	import local.views.topbar.TopBarGem;
	import local.views.topbar.TopBarStone;
	import local.views.topbar.TopBarUserName;
	import local.views.topbar.TopBarWood;
	
	public class TopBar extends BaseView
	{
		public var coinBar:TopBarCoin ;
		public var energyBar:TopBarEnergy;
		public var expBar:TopBarExp;
		public var stoneBar:TopBarStone;
		public var woodBar:TopBarWood;
		public var userBar:TopBarUserName;
		public var gemBar:TopBarGem;
		//===========================
		
		public function TopBar()
		{
			super();
		}
		
		private function userInfoUpdateHandler( e:UserInfoEvent ):void
		{
			var user:PlayerVO ;
			if(VillageModel.instance.isHome) {
				user = VillageModel.instance.me; 
			}else{
				user = VillageModel.instance.friend;
			}
			setUserInfo(user);
		}
		
		public function setUserInfo( user:PlayerVO ):void
		{
			coinBar.update( user.coin );
			energyBar.update( [user.energy , user.maxEnergy ]  );
			expBar.update( [user.exp , user.minExp , user.maxExp , user.level ] );
			stoneBar.update( user.stone );
			woodBar.update( user.wood );
			gemBar.update( user.cash ) ;
			userBar.update( user.name ) ;
		}
		
		/**更新topbar信息*/
		public function updateTopBar():void
		{
			setUserInfo( VillageModel.instance.me );
//			if(VillageModel.instance.isHome){
//				setUserInfo( VillageModel.instance.me );
//			}else{
//				setUserInfo( VillageModel.instance.friend );
//			}
		}
	}
}